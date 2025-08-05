extends Node3D
class_name Room

# List of possible directions. Revome from the list to negate that direction.
@onready var north_wall: Wall = $NorthWall
@onready var east_wall: Wall = $EastWall
@onready var south_wall: Wall = $SouthWall
@onready var west_wall: Wall = $WestWall

var coords: Vector2i ## Location in maze grid coords.
var dimensions: Vector2 = Vector2(2.0, 2.0) ## Meters.

func Reposition(maze_center: Vector2):
	position = Vector3(coords.x * dimensions.x - maze_center.x, 0, coords.y * dimensions.y - maze_center.y)

func OpenPassage(next_room: Room):
	# Knock down NORTH wall?
	if next_room.coords.y < coords.y:
		north_wall.queue_free()
		next_room.south_wall.queue_free()
	
	# Knock down EAST wall?
	if next_room.coords.x > coords.x:
		east_wall.queue_free()
		next_room.west_wall.queue_free()
	
	# Knock down SOUTH wall?
	if next_room.coords.y > coords.y:
		south_wall.queue_free()
		next_room.north_wall.queue_free()
	
	# Knock down WEST wall?
	if next_room.coords.x < coords.x:
		west_wall.queue_free()
		next_room.east_wall.queue_free()
