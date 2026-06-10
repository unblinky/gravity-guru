extends Area3D
class_name Scout

var maze: Maze

func _ready() -> void:
	maze = get_parent()
	body_entered.connect(on_body_entered)

func on_body_entered(body):
	if body is Ball:
		maze.main.start_maze()
