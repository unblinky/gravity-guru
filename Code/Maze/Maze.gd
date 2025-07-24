# What do I intend to do?
# Perfect Maze:
# - One path to each cell in the grid.

extends Node3D
class_name Maze

const ROOM: PackedScene = preload("res://Room/Room.tscn")

var tilt_speed: float = 75.0 # Degrees / sec.
var maze_width: int = 5 # Grid units.
var maze_height: int = 4 # Grid units.

func _ready() -> void:
	var room_count = maze_width * maze_height
	var ranger: Vector2i = Vector2i(2, 4) # Grid space.
	var ranger_speed: float = 1 # Grid speed.
	var breadcrumbs: Array[Vector2i] = []
	
	# Setup loop.
	#if not breadcrumbs.is_empty():
	for i in room_count:
		# Check for breadcrumbs.
		if breadcrumbs.has(ranger):
			print("Been here before: ", ranger)
			ranger = breadcrumbs.pop_back()
		else:
			var room: Room = SpawnRoom(ranger)
			
			print(">>>>>>>>>>>", breadcrumbs.back())
			
			
			
			
			breadcrumbs.append(ranger)
			
			# TODO: Is this random?
			var rando_index: int = randi_range(0, room.walls.size() - 1)
			print("Random index: ", rando_index)
			
			# Checking for maze boundries.
			
			
			# Pick a direction based on remaining walls.
			#var rando_direction = room.walls.pop_at(rando_index).wall.direction
			var rando_wall = room.walls.pop_at(rando_index)
			
			match rando_wall.direction:
				Wall.Direction.NORTH:
					# Check North.
					if ranger.y - ranger_speed > 0:
						rando_wall.queue_free()
						ranger.y -= ranger_speed
				
				Wall.Direction.EAST:
					# Check East.
					if ranger.x + ranger_speed < maze_width:
						rando_wall.queue_free()
						ranger.x += ranger_speed
					
				Wall.Direction.SOUTH:
					ranger.y += ranger_speed
					# Check South.
					if ranger.y + ranger_speed < maze_height:
						rando_wall.queue_free()
						ranger.y += ranger_speed

				Wall.Direction.WEST:
					# Check West.
					if ranger.x - ranger_speed > 0:
						rando_wall.queue_free()
						ranger.x -= ranger_speed
		
		
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
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
		
		await get_tree().create_timer(0.2).timeout


func _process(delta: float) -> void:
	# TODO: Feature request use mouse input.
	if Input.is_action_pressed("tilt_left"):
		rotation_degrees.z += tilt_speed * delta
	if Input.is_action_pressed("tilt_right"):
		rotation_degrees.z -= tilt_speed * delta
	if Input.is_action_pressed("tilt_forward"):
		rotation_degrees.x -= tilt_speed * delta
	if Input.is_action_pressed("tilt_back"):
		rotation_degrees.x += tilt_speed * delta

func SpawnRoom(grid: Vector2):
	var room = ROOM.instantiate()
	var maze_offset: Vector3 = Vector3(maze_width * room.size.x / 2.0 - 1, 0, maze_height * room.size.y / 2.0 - 1)
	room.position = Vector3(grid.x * room.size.x, 0, grid.y * room.size.y) - maze_offset
	add_child(room) # Display the graphics.
	return room
