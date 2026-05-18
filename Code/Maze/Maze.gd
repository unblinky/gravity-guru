extends Node3D
class_name Maze

const ROOM = preload("res://Room/Room.tscn")
@onready var scout: MeshInstance3D = $Scout

var breadcrumbs: Array[Room]

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
func oposite_direction(headed: Room.Direction) -> Room.Direction:
	return Room.Direction.WEST


func generate(columns: int, rows: int):
	var x_offset: float = (columns - 1) / 2.0
	var z_offset: float = (rows - 1) / 2.0
	
	#var rando_x = 2 # randi_range(0, columns - 1)
	#var rando_z = 1 # randi_range(0, rows - 1)
	var current_position: Vector2i = Vector2i(2, 1)
	
	# First Random Room
	var room: Room = ROOM.instantiate()
	room.position.x = current_position.x - x_offset
	room.position.z = current_position.y - z_offset
	add_child(room)
	breadcrumbs.append(room)
	scout.position = room.position
	
	
	var total_rooms: int = 6
	#var total_rooms: int = columns * rows
	
	for r in total_rooms:
		await get_tree().create_timer(0.4).timeout
		
		# TODO: Pick a direction.
		# Testing East
		var headed: Room.Direction = Room.Direction.EAST
		room.remove_wall(headed)
		
		# Next Room
		room = ROOM.instantiate()
		room.position.x = current_position.x + doit().x - x_offset
		room.position.z = current_position.y + doit().y - z_offset
		add_child(room)
		
		room.remove_wall(oposite_direction(headed))
		breadcrumbs.append(room)
		scout.position = room.position
		
		#match next_direction:
			#Vector2i.LEFT:
				#room.remove_wall(Room.Direction.RIGHT)
			#Vector2i.RIGHT:
				#room.remove_wall(Room.Direction.LEFT)
			#Vector2i.UP:
				#room.remove_wall(Room.Direction.FORWARD)
			#Vector2i.DOWN:
				#room.remove_wall(Room.Direction.BACK)
			
		current_position += doit()


func doit():
	return Vector2i.RIGHT
