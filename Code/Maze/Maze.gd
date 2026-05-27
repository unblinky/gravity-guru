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



func generate(columns: int, rows: int):
	offset.x = (columns - 1) / 2.0
	offset.z = (rows - 1) / 2.0
	# FIXME: Double-check
	position -= offset
	
	## Stores the 2D grid position.
	var current_plot: Vector2i = Vector2i(2, 1) # FIXME: Rando here.
	var current_room: Room
	var total_rooms: int = 6
	#var total_rooms: int = columns * rows
	
	# First Random Room
	current_room = spawn_room(current_plot)
	
	for r in total_rooms:
		await get_tree().create_timer(0.4).timeout
		print(plots_visited)
		
		# FIXME: Pick a direction.
		var headed: Vector2i = current_room.next_direction()
		if headed == Vector2i.ZERO:
			print("Error! Wall.Direction.NONE")
			return
		
		# FIXME: Validating plot...
		#if current_plot += headed:
			
		
		current_room.remove_wall(headed)
		
		# Next Room
		# FIXME: RESUME HERE.....
		current_plot += find_valid_plot(headed)
		
		
		current_room = spawn_room(current_plot)
		
		
		
		
		# Error checked example of remove wall.
		var oposite_direction = oposite_direction(headed)
		if oposite_direction == Wall.Direction.NONE:
			print("Error! Wall.Direction.NONE")
			return
		current_room.remove_wall(oposite_direction)


func spawn_room(plot: Vector2i) -> Room:
	var room: Room = ROOM.instantiate()
	room.maze = self
	room.position.x = plot.x
	room.position.z = plot.y
	add_child(room)
	
	breadcrumbs.append(room)
	plots_visited.append(plot)
	scout.position = room.position
	return room


# Validate a new plot (x,y).
# HACK: testing walls...
func find_valid_plot() -> Vector2i:
	# Return a plot based on remaining walls.
	#return Vector2i.RIGHT
	return Vector2i.LEFT
	#return Vector2i.UP
	#return Vector2i.DOWN
	
