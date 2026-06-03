extends RigidBody3D
class_name Ball

var kill_floor: int = -15 # meters.

func _physics_process(_delta: float) -> void:
	if position.y <= kill_floor:
		queue_free()
