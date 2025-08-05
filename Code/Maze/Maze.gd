# What do I intend to do?
# Perfect Maze:
# - One path to each cell in the grid.

extends Node3D
class_name Maze

const ROOM: PackedScene = preload("res://Room/Room.tscn")
const ROLLER: PackedScene = preload("res://Roller/Roller.tscn")
const GOAL: PackedScene = preload("res://Goal/Goal.tscn")

#const RANGER: PackedScene = preload("res://Ranger/Ranger.tscn")

# Input.
var tilt_speed: float = 75.0 # Degrees / sec.
var mouse_sensitivity: float = 0.06
var dragging: bool = false

# Maze generation.
var await_time: float = 0.1

# Lerping.
var post_drag_maze_rotation: Vector3
var lerp_speed: float = 1.5 ## radians / sec.
var weight_x: float = 1.0 ## Pitch.
var weight_z: float = 1.0 ## Roll.

var main: Main


## Generate a random maze.
func Generate(dimensions: Vector2i):
	var total_rooms: int = dimensions.x * dimensions.y ## Use to stop looping.
	var visited_coords: Array[Vector2i] ## Only grows. Use to stop looping.
	var breadcrumbs: Array[Room] ## Grows and shrinks. Store rooms that we can backtrack.
	
	# Spawn the starting room.
	var current_room: Room = ROOM.instantiate()
	# Pick a random starting place.
	current_room.coords = Vector2(randi_range(0, dimensions.x - 1), randi_range(0, dimensions.y - 1))
	add_child(current_room) # Add to the scene.
	
	# Find the maze's center so we can offset the rooms around the origin.
	var maze_center: Vector2
	maze_center.x = dimensions.x * current_room.dimensions.x / 2.0 - 1
	maze_center.y = dimensions.y * current_room.dimensions.y / 2.0 - 1
	current_room.Reposition(maze_center)
	
	#var ranger = RANGER.instantiate()
	#ranger.position = current_room.position
	#add_child(ranger)
	
	# Store location in order to find the next room.
	breadcrumbs.append(current_room) # Grows and shrinks.
	visited_coords.append(current_room.coords) # Only increases.
	
	while visited_coords.size() < total_rooms:
		# Pause the execution of our game for a bit.
		await get_tree().create_timer(await_time).timeout
		
		var grid_neighbors: Array[Vector2i] # In coords.
		
		# As long as the room is NOT located along the NORTH side.
		if current_room.coords.y > 0:
			var north: Vector2i = current_room.coords + Vector2i.UP
			if not visited_coords.has(north):
				grid_neighbors.append(north)
			
		# As long as the room is NOT located along the EAST side.
		if current_room.coords.x < dimensions.x - 1:
			var east: Vector2i = current_room.coords + Vector2i.RIGHT
			if not visited_coords.has(east):
				grid_neighbors.append(east)
			
		# As long as the room is NOT located along the SOUTH side.
		if current_room.coords.y < dimensions.y - 1:
			var south: Vector2i = current_room.coords + Vector2i.DOWN
			if not visited_coords.has(south):
				grid_neighbors.append(south)
			
		# As long as the room is NOT located along the WEST side.
		if current_room.coords.x > 0:
			var west: Vector2i = current_room.coords + Vector2i.LEFT
			if not visited_coords.has(west):
				grid_neighbors.append(west)
		
		# Pick up a breadcrumb.
		if grid_neighbors.is_empty():
			current_room = breadcrumbs.pop_back() # Backtrack using the last added room.
		else:
			var neighbor_coords: Vector2i = grid_neighbors.pop_at(randi_range(0, grid_neighbors.size() - 1))
			
			var next_room: Room = ROOM.instantiate()
			next_room.coords = neighbor_coords
			add_child(next_room)
			next_room.Reposition(maze_center)
			current_room.OpenPassage(next_room) # Knock down walls between both rooms.
			current_room = next_room
			
			breadcrumbs.append(current_room)
			visited_coords.append(current_room.coords)
	
	# Before exiting the maze generation.
	var roller = ROLLER.instantiate()
	
	var rando = randi_range(0, visited_coords.size() - 1)
	var coord = visited_coords.pop_at(rando)
	
	roller.drop_point.x = coord.x * current_room.dimensions.x - maze_center.x
	roller.drop_point.z = coord.y * current_room.dimensions.y - maze_center.y	
	main.add_child(roller) # Spawn to main.
	
	coord = visited_coords.pick_random()
	
	var goal = GOAL.instantiate()
	goal.main = main
	goal.position.x = coord.x * current_room.dimensions.x - maze_center.x
	goal.position.z = coord.y * current_room.dimensions.y - maze_center.y
	add_child(goal)
	
	#ranger.position = current_room.position


func _process(delta: float) -> void:
	if Input.is_action_pressed("tilt_left"):
		rotation_degrees.z += tilt_speed * delta
	if Input.is_action_pressed("tilt_right"):
		rotation_degrees.z -= tilt_speed * delta
	if Input.is_action_pressed("tilt_forward"):
		rotation_degrees.x -= tilt_speed * delta
	if Input.is_action_pressed("tilt_back"):
		rotation_degrees.x += tilt_speed * delta
	
	# TODO: Feature request use mouse input.
	if not dragging:
		if weight_x < 1.0:
			rotation.x = lerp(post_drag_maze_rotation.x, 0.0, weight_x)
			weight_x += lerp_speed * delta
		if weight_z < 1.0:
			rotation.z = lerp(post_drag_maze_rotation.z, 0.0, weight_z)
			weight_z += lerp_speed * delta


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				dragging = true
			else:
				# Mouse button up.
				dragging = false
				post_drag_maze_rotation = rotation
				weight_x = 0.0
				weight_z = 0.0

	if event is InputEventMouseMotion:
		if dragging:
			rotation_degrees.x += event.relative.y * mouse_sensitivity
			rotation_degrees.z -= event.relative.x * mouse_sensitivity
			#print("Relative: ", event.relative)
