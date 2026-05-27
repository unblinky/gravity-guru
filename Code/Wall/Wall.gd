extends StaticBody3D
class_name Wall

#
#enum Direction {
	#NONE,
	#NORTH,
	#EAST,
	#SOUTH,
	#WEST
#}

# HACK: No conversions...
const NORTH: Vector2i = Vector2i.UP
const EAST: Vector2i = Vector2i.RIGHT
const SOUTH: Vector2i = Vector2i.DOWN
const WEST: Vector2i = Vector2i.LEFT

@onready var collider: CollisionShape3D = $Collider
@onready var graphics: MeshInstance3D = $Graphics

## Drag in a StandardMaterial3D.
@export var material: StandardMaterial3D

var direction: Vector2i

func _ready() -> void:
	if position.x < 0:
		direction = WEST
	elif position.x > 0:
		direction = EAST
	elif position.z < 0:
		direction = NORTH
	elif position.z > 0:
		direction = SOUTH
	graphics.material_override = material

func disable():
	graphics.hide()
	collider.disabled = true
