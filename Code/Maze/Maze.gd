extends Node3D
class_name Maze

const ROOM = preload("res://Room/Room.tscn")


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
		#rotate(Vector3.FORWARD, 1.5)


func generate(columns: int, rows: int):
	var x_offset: float = (columns - 1) / 2.0
	var z_offset: float = (rows - 1) / 2.0
	
	for row in rows:
		for column in columns:
			var room: Room = ROOM.instantiate()
			room.position.x = column - x_offset
			room.position.z = row - z_offset
			add_child(room)
