extends Node
class_name Main

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		# TODO: Needs a menu...
		get_tree().quit()
