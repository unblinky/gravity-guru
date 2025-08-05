extends Area3D
class_name Goal

var main: Main

func _ready() -> void:
	body_entered.connect(OnBodyEntered)

func OnBodyEntered(body):
	if body is Roller:
		print("GOAL!!!!")
		body.can_repawn = false
		main.NextMaze()
