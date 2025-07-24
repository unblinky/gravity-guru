extends Node3D
class_name Room

var size: Vector2 = Vector2(2.0, 2.0) # Meters squared (area).

@onready var walls: Array[Wall] = [$NorthWall, $EastWall, $SouthWall, $WestWall]


func RemoveWall(direction: Wall.Direction):
	var index: int = walls.find(direction)
	if index <= -1:
		var wall = walls.pop_at(index)
		wall.queue_free()
		# TODO: Test if this shrinks the walls array.


func DisableWall(direction: Wall.Direction):
	var index = walls.find(direction)
	if index <= -1:
		walls.remove_at(index)



func RemoveRandomWall() -> Wall:
	var rando_index: int = randi_range(0, walls.size() - 1)
	return walls.pop_at(rando_index)
