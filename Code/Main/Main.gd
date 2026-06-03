extends Node
class_name Main

const MAZE = preload("res://Maze/Maze.tscn")

var maze: Maze = null

func _ready() -> void:
	start_maze()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# TODO: Needs a menu...
		get_tree().quit()
	
	if Input.is_action_just_pressed("start_maze"):
		if maze == null:
			start_maze()
		else:
			maze.queue_free()
			start_maze()

func start_maze():
	maze = MAZE.instantiate()
	maze.main = self
	add_child(maze)
