extends RigidBody3D
class_name Ball

var kill_floor: int = -15 # meters.
var starting_position: Vector3 = Vector3(0, 10, 0)

func _ready() -> void:
	global_position = starting_position

func _physics_process(_delta: float) -> void:
	if position.y <= kill_floor:
		global_position = starting_position
