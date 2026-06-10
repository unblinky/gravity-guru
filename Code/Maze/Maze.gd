extends Node3D
class_name Maze

const BALL = preload("res://Ball/Ball.tscn")
const ROOM = preload("res://Room/Room.tscn")
@onready var scout = $Scout

var main: Main
var ball: Ball
var offset: Vector3
var plot_min: int = 2
var plot_max: int = 8

func _ready() -> void:
	generate(randi_range(plot_min, plot_max), randi_range(plot_min, plot_max))

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("tilt_left"):
		rotation_degrees.z += 2.0
	if Input.is_action_pressed("tilt_right"):
		rotation_degrees.z -= 2.0
	if Input.is_action_pressed("tilt_forward"):
		rotation_degrees.x -= 2.0
	if Input.is_action_pressed("tilt_back"):
		# FIXME:
		# What physics engine?
		# Physics solution for rotating maze?
		rotation_degrees.x += 2.0

func generate(columns: int, rows: int):
	var breadcrumbs: Array[Room] # Grow and shrink. pop_at()
	var plots_visited: Array[Vector2i] # Only grows.
	
	offset.x = (columns - 1) / 2.0
	offset.z = (rows - 1) / 2.0
	# FIXME: Double-check
	#position -= offset
	
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
	current_room.position.x = current_plot.x - offset.x
	current_room.position.z = current_plot.y - offset.z
	add_child(current_room)
	breadcrumbs.append(current_room)
	plots_visited.append(current_plot)
	scout.position = current_room.position
	print(plots_visited)
	
	
	# How many times? It's different every time?
	while plots_visited.size() < total_rooms:
		await get_tree().create_timer(0.1).timeout
		
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
			
			# FIXME: Next Room Code Dup?
			var next_room: Room = ROOM.instantiate()
			next_room.maze = self
			next_room.plot = neighbor_plot
			next_room.position.x = neighbor_plot.x - offset.x
			next_room.position.z = neighbor_plot.y - offset.z
			add_child(next_room)
			breadcrumbs.append(next_room)
			plots_visited.append(next_room.plot)
			scout.position = next_room.position
			print(plots_visited)
			# end dup?
			
			current_room.open_passage(next_room)
			
			# Increment current room.
			current_room = next_room
	
	ball = BALL.instantiate()
	main.add_child(ball)
