extends Node3D
class_name Maze

const ROOM = preload("res://Room/Room.tscn")
const BALL = preload("res://Ball/Ball.tscn")

@onready var offset: Node3D = $Offset
@onready var scout: MeshInstance3D = $Offset/Scout

@export var dimensions: Vector2i = Vector2i(4, 4)

func _ready() -> void:
	generate(dimensions.x, dimensions.y)

func _process(delta: float) -> void:
	if Input.is_action_pressed("tilt_left"):
		rotation_degrees.z += 2.0
	if Input.is_action_pressed("tilt_right"):
		rotation_degrees.z -= 2.0
	if Input.is_action_pressed("tilt_forward"):
		rotation_degrees.x -= 2.0
	if Input.is_action_pressed("tilt_back"):
		rotation_degrees.x += 2.0

## Generate a random "perfect maze" level.
func generate(columns: int, rows: int):
	var breadcrumbs: Array[Room] # Grow and shrink. pop_at()
	var plots_visited: Array[Vector2i] # Only grows.
	
	# FIXME: Double-check
	var pos: Vector3
	pos.x = (columns - 1) / 2.0
	pos.z = (rows - 1) / 2.0
	offset.position -= pos
	
	## Stores the 2D grid position.
	var current_plot: Vector2i = Vector2i(randi_range(0, columns - 1), randi_range(0, rows - 1))
	var current_room: Room
	var total_rooms: int = columns * rows
	
	# First Random Room
	#current_room = spawn_room(current_plot)
	
	# FIXME: Surrent Room Code dup?
	current_room = ROOM.instantiate()
	current_room.maze = self
	current_room.plot = current_plot
	offset.add_child(current_room)
	current_room.position.x = current_plot.x
	current_room.position.z = current_plot.y
	breadcrumbs.append(current_room)
	plots_visited.append(current_plot)
	scout.position = current_room.position
	print(plots_visited)
	
	
	# How many times? It's different every time?
	while plots_visited.size() < total_rooms:
		await get_tree().create_timer(0.4).timeout
		
		# FIXME: Pick a direction.
		#var headed: Vector2i = current_room.next_direction()
		#if headed == Vector2i.ZERO:
			#print("Error! Wall.Direction.NONE")
			#return
		
		# FIXME: Validating plot...
		var grid_neighbors: Array[Vector2i]
		
		# As long as the room is NOT located along the NORTH side.
		if current_room.plot.y > 0:
			var north: Vector2i = current_room.plot + Vector2i.UP
			if not plots_visited.has(north):
				grid_neighbors.append(north)
		
		# As long as the... NOT located along the EAST...
		if current_room.plot.x < columns - 1:
			var east: Vector2i = current_room.plot + Vector2i.RIGHT
			if not plots_visited.has(east):
				grid_neighbors.append(east)
		
		# As long as the... NOT located along the SOUTH...
		if current_room.plot.y < rows - 1:
			var south: Vector2i = current_room.plot + Vector2i.DOWN
			if not plots_visited.has(south):
				grid_neighbors.append(south)
		
		# As long as the... NOT located along the WEST...
		if current_room.plot.x > 0:
			var west: Vector2i = current_room.plot + Vector2i.LEFT
			if not plots_visited.has(west):
				grid_neighbors.append(west)
		
		# Pick up a breadcrumb.
		if grid_neighbors.is_empty():
			current_room = breadcrumbs.pop_back()
			scout.position = current_room.position
		else:
			var neighbor_plot: Vector2i = grid_neighbors.pop_at(randi_range(0, grid_neighbors.size() - 1))
			
			#var next_room = spawn_room()
			# FIXME: Next Room Code Dup?
			var next_room: Room = ROOM.instantiate()
			next_room.maze = self
			next_room.plot = neighbor_plot
			offset.add_child(next_room)
			next_room.position.x = neighbor_plot.x
			next_room.position.z = neighbor_plot.y
			breadcrumbs.append(next_room)
			plots_visited.append(next_room.plot)
			scout.position = next_room.position
			print(plots_visited)
			# end dup?
			
			current_room.open_passage(next_room)
			
			# Increment current room.
			current_room = next_room
	
	# Drop the ball.
	var ball = BALL.instantiate()
	ball.position.y = - 10
	get_parent().add_child(ball)


#func spawn_room():
	#var next_room: Room = ROOM.instantiate()
	#next_room.maze = self
	#next_room.plot = neighbor_plot
	#offset.add_child(next_room)
	#next_room.position.x = neighbor_plot.x
	#next_room.position.z = neighbor_plot.y
	#breadcrumbs.append(next_room)
	#plots_visited.append(next_room.plot)
	#scout.position = next_room.position
	#print(plots_visited)

#
#func spawn_room(plot: Vector2i) -> Room:
	#var room: Room = ROOM.instantiate()
	#room.maze = self
	#room.position.x = plot.x
	#room.position.z = plot.y
	#add_child(room)
	#
	#breadcrumbs.append(room)
	#plots_visited.append(plot)
	#scout.position = room.position
	#return room
#
#
## Validate a new plot (x,y).
## HACK: testing walls...
#func find_valid_plot() -> Vector2i:
	## Return a plot based on remaining walls.
	##return Vector2i.RIGHT
	#return Vector2i.LEFT
	##return Vector2i.UP
	##return Vector2i.DOWN
	#
