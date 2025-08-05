extends RigidBody3D
class_name Roller

var drop_point: Vector3 = Vector3(0, 10, 0)
var can_repawn = true
var kill_floor = -10

func _ready() -> void:
	position = drop_point

func _process(delta: float) -> void:
	if position.y < kill_floor:
		if can_repawn:
			position = drop_point
			linear_velocity = Vector3.ZERO
		else:
			queue_free()
