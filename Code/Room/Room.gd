extends Node3D
class_name Room

enum Direction {
	NORTH,
	EAST,
	SOUTH,
	WEST
}

@onready var north_wall: Wall = $NorthWall
@onready var east_wall: Wall = $EastWall
@onready var south_wall: Wall = $SouthWall
@onready var west_wall: Wall = $WestWall

# List of our orginal walls.
var walls: Array[Wall]

# TODO: Wall logic & bounds.

func _ready() -> void:
	north_wall.show()
	east_wall.show()
	south_wall.show()
	west_wall.show()
	
	walls.append(north_wall)
	walls.append(east_wall)
	walls.append(south_wall)
	walls.append(west_wall)


#func next_direction() -> Direction:
	# FIXME: Uncomment...
	#var wall: Wall = walls.pick_random()
	#walls.erase(wall)
	
	#if wall.position.x < 0:
		#return Vector2i.LEFT
	#if wall.position.x > 0:
		#return Vector2i.RIGHT
	#if wall.position.z < 0:
		#return Vector2i.UP
	#if wall.position.z > 0:
		#return Vector2i.DOWN
	
	#return Direction.EAST

#
#
## Hide, dissable a wall.
func remove_wall(direction: Direction):
	match direction:
		Direction.NORTH:
			north_wall.disable()
			walls.erase(north_wall)
		Direction.EAST:
			east_wall.disable()
			walls.erase(east_wall)
		Direction.SOUTH:
			south_wall.disable()
			walls.erase(south_wall)
		Direction.WEST:
			west_wall.disable()
			walls.erase(west_wall)
