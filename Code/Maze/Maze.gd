extends Node3D
class_name Maze

const ROOM = preload("res://Room/Room.tscn")
@onready var scout: MeshInstance3D = $Scout


var breadcrumbs: Array[Room]
var plots_visited: Array[Vector2i]
var offset: Vector3

func _ready() -> void:
	generate(5, 5)

func _process(delta: float) -> void:
	if Input.is_action_pressed("tilt_left"):
		rotation_degrees.z += 2.0
	if Input.is_action_pressed("tilt_right"):
		rotation_degrees.z -= 2.0
	if Input.is_action_pressed("tilt_forward"):
		rotation_degrees.x -= 2.0
	if Input.is_action_pressed("tilt_back"):
		rotation_degrees.x += 2.0


# TODO: Refactor to Room?
func oposite_direction(headed: Wall.Direction) -> Wall.Direction:
	return Wall.Direction.WEST


func generate(columns: int, rows: int):
	offset.x = (columns - 1) / 2.0
	offset.z = (rows - 1) / 2.0
	# FIXME: Double-check
	position -= offset
	
	#var rando_x = 2 # randi_range(0, columns - 1)
	#var rando_z = 1 # randi_range(0, rows - 1)
	## Stores the 2D grid position.
	var current_plot: Vector2i = Vector2i(2, 1)
	var room: Room
	
	# First Random Room
	room = spawn_room(current_plot)

	var total_rooms: int = 6
	#var total_rooms: int = columns * rows
	
	for r in total_rooms:
		await get_tree().create_timer(0.4).timeout
		print(plots_visited)
		
		# TODO: Pick a direction.
		# Testing East
		var headed: Wall.Direction = Wall.Direction.EAST
		room.remove_wall(headed)
		
		# Next Room
		current_plot += find_valid_plot()
		spawn_room(current_plot)
		room.remove_wall(oposite_direction(headed))
		
		#match next_direction:
			#Vector2i.LEFT:
				#room.remove_wall(Room.Direction.RIGHT)
			#Vector2i.RIGHT:
				#room.remove_wall(Room.Direction.LEFT)
			#Vector2i.UP:
				#room.remove_wall(Room.Direction.FORWARD)
			#Vector2i.DOWN:
				#room.remove_wall(Room.Direction.BACK)
	



func spawn_room(plot: Vector2i) -> Room:
	var room: Room = ROOM.instantiate()
	room.position.x = plot.x
	room.position.z = plot.y
	add_child(room)
	
	breadcrumbs.append(room)
	plots_visited.append(plot)
	scout.position = room.position
	return room


# Validate a new plot.
# TODO: 
func find_valid_plot() -> Vector2i:
	return Vector2i.RIGHT
