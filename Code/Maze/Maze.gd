# What do I intend to do?
# Perfect Maze:
# - One path to each cell in the grid.

extends Node3D
class_name Maze

const ROOM: PackedScene = preload("res://Room/Room.tscn")
const RANGER: PackedScene = preload("res://Ranger/Ranger.tscn")

# Input.
var tilt_speed: float = 75.0 # Degrees / sec.
var mouse_sensitivity: float = 0.06
var dragging: bool = false

# Maze generation.
var await_time: float = 0.4
var maze_width: int = 10 # Grid units.
var maze_height: int = 10 # Grid units.
var maze_offset: Vector3 ## Use to center the maze under the camera based on width and height.
var room_count: int = 0 ## Number of rooms built so far.
var total_rooms: int = maze_width * maze_height ## Build this many rooms.

var ranger: Vector2i = Vector2i(0, 0) ## The "play head" for the current location in Grid space.
var ranger_speed: float = 1 ## Grid distance per move.

var current_room: Room ## Holds the current room while we tinker with it.
var breadcrumbs: Array[Room] = [] ## A list of rooms where the ranger has been.

# Lerping.
var post_drag_maze_rotation: Vector3
var lerp_speed: float = 1.5 # radians / sec.

# TODO: Quatrenion sollution?
var weight_x: float = 1.0 ## Pitch.
var weight_z: float = 1.0 ## Roll.


func _ready() -> void:
	Generate(Vector2(5, 5))


## Generate a random maze.
func Generate(dimensions: Vector2i):
	var total_rooms: int = dimensions.x * dimensions.y
	var breadcrumbs: Array[Room] # Grows and shrinks.
	var visited_coords: Array[Vector2i] # Only grow.
	
	# Spawn the starting room.
	var current_room: Room = ROOM.instantiate()
	current_room.coords = Vector2(randi_range(0, dimensions.x - 1), randi_range(0, dimensions.y - 1))
	add_child(current_room)
	
	# Find the maze's center so we can offset the rooms around the origin.
	var maze_center: Vector2
	maze_center.x = dimensions.x * current_room.dimensions.x / 2.0 - 1
	maze_center.y = dimensions.y * current_room.dimensions.y / 2.0 - 1
	current_room.Reposition(maze_center)
	
	var ranger = RANGER.instantiate()
	ranger.position = current_room.position
	add_child(ranger)
	
	# Store location in order to find the next room.
	breadcrumbs.append(current_room) # Grow and shrink.
	visited_coords.append(current_room.coords) # Only increases.
	
	while visited_coords.size() < total_rooms:
		# Pause the execution of our game for a bit.
		await get_tree().create_timer(await_time).timeout
		
		var grid_neighbors: Array[Vector2i]
		
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
			current_room = breadcrumbs.pop_back()
		else:
			var neighbor_coords: Vector2i = grid_neighbors.pop_at(randi_range(0, grid_neighbors.size() - 1))
			
			var next_room: Room = ROOM.instantiate()
			next_room.coords = neighbor_coords
			add_child(next_room)
			next_room.Reposition(maze_center)
			current_room.OpenPassage(next_room)
			current_room = next_room
			
			breadcrumbs.append(current_room)
			visited_coords.append(current_room.coords)
		
		ranger.position = current_room.position


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
			print("Relative: ", event.relative)




#
#
### Create and validate a scouting location. Run from a loop.
#func ScoutAndBuild():
	#var wall = current_room.DisableRandomWall()
	#
	## No more walls to search with.
	#if wall == null:
		#if not breadcrumbs.is_empty():
			## Pop the last element in the array to rewind the `current_room`.
			#current_room = breadcrumbs.pop_back()
	#
	## Scout the location in the wall's direciton.
	#else:
		#var scout: Vector2i = current_room.grid_location
		#match wall.direction:
			#Wall.Direction.NORTH:
				#scout.y -= 1
			#Wall.Direction.EAST:
				#scout.x += 1
			#Wall.Direction.SOUTH:
				#scout.y += 1
			#Wall.Direction.WEST:
				#scout.x -= 1
		#
		## Checking for valid maze boundries.
		#if scout.x >= 0 && scout.x < maze_width && scout.y >= 0 && scout.y < maze_height:
			## Have we already built a room here?
			#if not SearchBreadcrumbs(scout):
				#wall.queue_free() # Knock out the scouting wall.
				#BuildRoom(scout, ranger)
#
#
### Returns true if found.
#func SearchBreadcrumbs(location: Vector2i):
	#for room in breadcrumbs:
		## Found the grid location in the breadcrumbs.
		#if room.grid_location == location:
			#return true
	#return false
#
#
### Spawn a room around the `scout` location and knock down the wall between the `ranger` location.
#func BuildRoom(scout: Vector2i, ranger: Vector2i):
	#await get_tree().create_timer(0.8).timeout
	#print("New Room at: ", scout)
	#
	#var room = ROOM.instantiate()
	#room.grid_location = scout
	#room.position = Vector3(scout.x * room.size.x, 0, scout.y * room.size.y) - maze_offset
	#add_child(room) # Add the new room to the scene tree.
	#breadcrumbs.append(room) # Add to the end of the breadcrumbs list.
	#room_count += 1
	#print("Room count: ", room_count)
	#
	## Which wall do we want to knock down?
	#if  ranger.y < scout.y:
		#room.RemoveWall(Wall.Direction.NORTH)
	#elif ranger.x > scout.x:
		#room.RemoveWall(Wall.Direction.EAST)
	#elif ranger.y > scout.y:
		#room.RemoveWall(Wall.Direction.SOUTH)
	#elif ranger.x < scout.x:
		#room.RemoveWall(Wall.Direction.WEST)
	#else:
		#print("Should never get here.")
	#
	#ranger = room.grid_location
	#current_room = room
