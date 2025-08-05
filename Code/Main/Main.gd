extends Node
class_name Main

const MAZE = preload("res://Maze/Maze.tscn")

func _ready() -> void:
	var maze = MAZE.instantiate()
	add_child(maze)
