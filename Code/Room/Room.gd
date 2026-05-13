extends Node3D
class_name Room

@onready var left_wall: Wall = $LeftWall
@onready var right_wall: Wall = $RightWall
@onready var forward_wall: Wall = $ForwardWall
@onready var back_wall: Wall = $BackWall

enum Direction {
	LEFT,
	RIGHT,
	FORWARD,
	BACK
}


# TODO: Wall logic & bounds.


# Hide, dissable a wall.
func remove_wall(direction: Direction):
	match direction:
		Direction.LEFT:
			left_wall.disable()
		Direction.RIGHT:
			right_wall.disable()
		Direction.FORWARD:
			forward_wall.disable()
		Direction.BACK:
			back_wall.disable()
	
	
