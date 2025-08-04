# What do I intend to do?
# Perfect Maze:
# - One path to each cell in the grid.

extends Node3D
class_name Maze

const ROOM: PackedScene = preload("res://Room/Room.tscn")

# Input.
var tilt_speed: float = 75.0 # Degrees / sec.
var mouse_sensitivity: float = 0.06
var dragging: bool = false

# Maze generation.
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
	print("Total Rooms: ", total_rooms)
	
	# Place the starting room.
	current_room = ROOM.instantiate()
	
	# Use the `curren_room` to set the `maze_offset`.
	maze_offset = Vector3(maze_width * current_room.size.x / 2.0 - 1, 0, maze_height * current_room.size.y / 2.0 - 1)
	current_room.grid_location = ranger
	current_room.position = Vector3(ranger.x * current_room.size.x, 0, ranger.y * current_room.size.y) - maze_offset
	add_child(current_room)
	breadcrumbs.append(current_room)
	room_count += 1
	
	# Scout in the direction of a random wall.
	#var location = current_room.DisableRandomWall()
	ScoutAndBuild(current_room)


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


## Recursive function.
func ScoutAndBuild(current_room: Room):
	print(breadcrumbs)
	
	# End recursion, condition.
	if room_count < 10:
		# current_room.grid_location.x + 1 
		var wall = current_room.DisableRandomWall()
		if wall != null:
			wall.queue_free()
		
		var scout: Vector2i = current_room.grid_location
		scout.x += 1
		SpawnRoom(scout, ranger) # Continue to the next room.
		#
		#
		#
		## No more walls to search with.
		#if wall == null:
			#if breadcrumbs.size() > 0:
				## Pop the last element in the array to rewind the `current_room`.
				#current_room = breadcrumbs.pop_back()
				#SeekAndBuild(current_room)
		#
		## Scout the location in the wall's direciton.
		#else:
			#var location: Vector2i
			#match wall.direction:
				#Wall.Direction.NORTH:
					#location.y -= 1
				#Wall.Direction.EAST:
					#location.x += 1
				#Wall.Direction.SOUTH:
					#location.y += 1
				#Wall.Direction.WEST:
					#location.x -= 1
			#
			## Have we already built a room here?
			#if SearchBreadcrumbs(location):
				#wall.queue_free()
				#SeekAndBuild(current_room)
			#
			## The `location` seems valid! Build the room.
			#else:
				#wall.queue_free()
				#SpawnRoom(location, ranger) # Continue to the next room.
#

## Returns true if found.
func SearchBreadcrumbs(location: Vector2i):
	for room in breadcrumbs:
		# Found the grid location in the breadcrumbs.
		if room.grid_location == location:
			return true
	return false


## Spawn a room at the `build_location` and knock down the wall between the ranger location.
func SpawnRoom(build_location: Vector2i, ranger: Vector2i):
	await get_tree().create_timer(0.2).timeout
	print("New Room at: ", build_location)
	
	var room = ROOM.instantiate()
	room.grid_location = build_location
	room.position = Vector3(build_location.x * room.size.x, 0, build_location.y * room.size.y) - maze_offset
	add_child(room) # Add the new room to the scene tree.
	breadcrumbs.append(room) # Add to the end of the breadcrumbs list.
	room_count += 1
	
	# Which wall do we want to knock down?
	if build_location.y < ranger.y:
		room.RemoveWall(Wall.Direction.NORTH)
	elif build_location.x > ranger.x:
		room.RemoveWall(Wall.Direction.EAST)
	elif build_location.y > ranger.y:
		room.RemoveWall(Wall.Direction.SOUTH)
	elif build_location.x < ranger.x:
		room.RemoveWall(Wall.Direction.WEST)
	else:
		print("Should never get here.")
	
	ranger = room.grid_location
	current_room = room
	ScoutAndBuild(current_room)



			## Checking for maze boundries.
			
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
