extends StaticBody3D
class_name Wall

@onready var collider: CollisionShape3D = $Collider
@onready var graphics: MeshInstance3D = $Graphics


## Drag in a StandardMaterial3D.
@export var material: StandardMaterial3D

func _ready() -> void:
	graphics.material_override = material

func disable():
	graphics.hide()
	collider.disabled = true
