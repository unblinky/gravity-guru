# What do I intend to do?
# Perfect Maze:
# - One path to each cell in the grid.

extends Node3D
class_name Maze

const ROOM: PackedScene = preload("res://Room/Room.tscn")

var maze_width: int = 4 # Grid units.
var maze_height: int = 4 # Grid units.
var maze_offset: Vector3

var tilt_speed: float = 75.0 # Degrees / sec.
var mouse_sensitivity: float = 0.06
var dragging: bool = false

# LERP
var post_drag_maze_rotation: Vector3 # A
var lerp_speed: float = 1.5 # radians / sec.

# TODO: Quatrenion sollution?
var weight_x: float = 1.0 ## Pitch.
var weight_z: float = 1.0 ## Roll.

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
		



func _ready() -> void:
	var room_count = maze_width * maze_height
	var ranger: Vector2i = Vector2i(0, 0) # Grid space.
	var ranger_speed: float = 1 # Grid speed.
	
	var breadcrumbs: Array[Room] = [] ## A list of visited grid points.
	
	
	# Pattern
	# Place room
	var first_room = ROOM.instantiate()
	maze_offset = Vector3(maze_width * first_room.size.x / 2.0 - 1, 0, maze_height * first_room.size.y / 2.0 - 1)
	first_room.position = Vector3(ranger.x * first_room.size.x, 0, ranger.y * first_room.size.y) - maze_offset
	add_child(first_room)
	
	
		# Where did we come from?
	# Room > breadcrumbs
	# Consume a wall from the list.
		# Is it valid move??????
			# Maze bounds.
			# Is in the breadcrumbs list.
		# Update ranger
	
	
	
	#
	## Setup loop.
	##if not breadcrumbs.is_empty():
	#for i in room_count:
		#
		#
		#
		#
		#
		#
		#
		## Check for breadcrumbs.
		#for crumb in breadcrumbs:
			## if we don't find it?
			#if crumb.grid_location == ranger:
				#print("Already been here.")
				#
			#
			#
			
			#
			#while room.grid_location != ranger:
				#print("Been here before: ", ranger)
				#print(room)
				#var current_room: Room = room
				#if room.grid_location == ranger:
#
					#var groom: Room = SpawnRoom(ranger)
					#breadcrumbs.append(room)
					#print(">>>>>>>>>>>", breadcrumbs.back())
		
			
			
			## TODO: Is this random?
			#var rando_index: int = randi_range(0, room.walls.size() - 1)
			#print("Random index: ", rando_index)
			#
			## Checking for maze boundries.
			#
			#
			## Pick a direction based on remaining walls.
			##var rando_direction = room.walls.pop_at(rando_index).wall.direction
			#var rando_wall = room.walls.pop_at(rando_index)
			#
			#match rando_wall.direction:
				#Wall.Direction.NORTH:
					## Check North.
					#if ranger.y - ranger_speed > 0:
						#rando_wall.queue_free()
						#ranger.y -= ranger_speed
				#
				#Wall.Direction.EAST:
					## Check East.
					#if ranger.x + ranger_speed < maze_width:
						#rando_wall.queue_free()
						#ranger.x += ranger_speed
					#
				#Wall.Direction.SOUTH:
					#ranger.y += ranger_speed
					## Check South.
					#if ranger.y + ranger_speed < maze_height:
						#rando_wall.queue_free()
						#ranger.y += ranger_speed
#
				#Wall.Direction.WEST:
					## Check West.
					#if ranger.x - ranger_speed > 0:
						#rando_wall.queue_free()
						#ranger.x -= ranger_speed
		#
		#
		#
			#
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			#var wall = room.walls.pop_at(rando_index)
			#if wall != null:
				#match wall.direction:
					#Wall.Direction.NORTH:
						#ranger.y -= ranger_speed
					#Wall.Direction.EAST:
						#ranger.x += ranger_speed
					#Wall.Direction.SOUTH:
						#ranger.y += ranger_speed
					#Wall.Direction.WEST:
						#ranger.x -= ranger_speed
				#
				#wall.queue_free()
		
		#await get_tree().create_timer(0.2).timeout





func SpawnRoom(grid_location: Vector2i, drop_wall: Wall.Direction):
	var room = ROOM.instantiate()
	room.grid_location = grid_location
	room.position = Vector3(grid_location.x * room.size.x, 0, grid_location.y * room.size.y) - maze_offset
	add_child(room) # Display the graphics.
	room.RemoveWall(drop_wall)
	return room
