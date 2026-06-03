extends Area3D
class_name Scout

var maze: Maze

func _ready() -> void:
	maze = get_parent()
	body_entered.connect(on_body_entered)

func on_body_entered(body):
	# FIXME: What happens when we reach the goal.
	# IF BALL.
	maze.main.start_maze()
