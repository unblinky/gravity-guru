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


# Returns Grid Coords for the next room to spawn.
# TODO: Validate the room / wall.
func pick_a_direction() -> Vector2i:
	var rando: int = randi_range(0, 3)
	
	match rando:
		0:
			return Vector2i.LEFT
		1:
			return Vector2i.RIGHT
		2:
			return Vector2i.UP
		3:
			return Vector2i.DOWN
		
	return Vector2i.ZERO


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
	
	
	var total_rooms: int = columns * rows
	
	for r in total_rooms:
		await get_tree().create_timer(0.4).timeout
		
		var next_direction: Vector2i = pick_a_direction()
		
		# Second Random Room
		room = ROOM.instantiate()
		room.position.x = current_position.x + next_direction.x - x_offset
		room.position.z = current_position.y + next_direction.y - z_offset
		add_child(room)
		
		match next_direction:
			Vector2i.LEFT:
				room.remove_wall(Room.Direction.RIGHT)
			Vector2i.RIGHT:
				room.remove_wall(Room.Direction.LEFT)
			Vector2i.UP:
				room.remove_wall(Room.Direction.FORWARD)
			Vector2i.DOWN:
				room.remove_wall(Room.Direction.BACK)
			
		current_position += next_direction
		
	

	
	# Grid success.
	#for row in rows:
		#for column in columns:
			#var room: Room = ROOM.instantiate()
			#room.position.x = column - x_offset
			#room.position.z = row - z_offset
			#add_child(room)
