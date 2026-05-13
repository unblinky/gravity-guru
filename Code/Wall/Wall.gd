extends StaticBody3D
class_name Wall

@onready var collider: CollisionShape3D = $Collider
@onready var graphics: MeshInstance3D = $Graphics

func disable():
	graphics.hide()
	collider.disabled = true
