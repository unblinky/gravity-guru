extends Node3D
class_name Room

## List of possible directions. Revome from the list to negate that direction.
@onready var walls: Array[Wall] = [$NorthWall, $EastWall, $SouthWall, $WestWall]

var grid_location: Vector2i ## Position in maze grid cords.
var size: Vector2 = Vector2(2.0, 2.0) # Meters squared (area).




func RemoveWall(direction: Wall.Direction):
	for wall in walls:
		if wall.direction == direction:
			wall.queue_free()


func DisableWall(direction: Wall.Direction):
	var index = walls.find(direction)
	if index <= -1:
		walls.remove_at(index)

#
#
#func RemoveRandomWall() -> Wall:
	#var rando_index: int = randi_range(0, walls.size() - 1)
	#return walls.pop_at(rando_index)
