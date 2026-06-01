extends Node3D
class_name Room

@onready var north_wall: Wall = $NorthWall
@onready var east_wall: Wall = $EastWall
@onready var south_wall: Wall = $SouthWall
@onready var west_wall: Wall = $WestWall

# List of our orginal walls.
var walls: Array[Wall]
var plot: Vector2i
var maze: Maze

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



# FIXME:
func next_direction() -> Vector2i:
	var direction: Vector2i
	var wall: Wall = walls.pick_random()
	walls.erase(wall)
	
	# Handle invalid X directions.
	if plot.x + wall.direction.x < 0:
		direction = next_direction()
	if plot.x + wall.direction.x > maze.columns:
		direction = next_direction()
	
	# Handle invalid Y directions.
	if plot.y + wall.direction.y < 0:
		direction = next_direction()
	if plot.y + wall.direction.y > maze.rows:
		direction = next_direction()
	return direction


#
#
## TODO: Refactor to Room?
#func oposite_direction(headed: Wall.Direction) -> Wall.Direction:
	#match headed:
		#Wall.Direction.NORTH:
			#return Wall.Direction.SOUTH
		#Wall.Direction.EAST:
			#return Wall.Direction.WEST
		#Wall.Direction.SOUTH:
			#return Wall.Direction.NORTH
		#Wall.Direction.WEST:
			#return Wall.Direction.EAST
	#return Wall.Direction.NONE
	#

func open_passage(next_room: Room):
	# Heading North
	if next_room.plot.y < self.plot.y:
		self.remove_wall(Vector2i.UP)
		next_room.remove_wall(Vector2i.DOWN)
	
	# Heading East
	if next_room.plot.x > self.plot.x:
		self.remove_wall(Vector2i.RIGHT)
		next_room.remove_wall(Vector2i.LEFT)
	
	# Heading South
	if next_room.plot.y > self.plot.y:
		self.remove_wall(Vector2i.DOWN)
		next_room.remove_wall(Vector2i.UP)
	
	# Heading West
	if next_room.plot.x < self.plot.x:
		self.remove_wall(Vector2i.LEFT)
		next_room.remove_wall(Vector2i.RIGHT)


## Hide, dissable a wall.
func remove_wall(direction: Vector2i):
	match direction:
		Vector2i.UP:
			north_wall.disable()
			walls.erase(north_wall)
		Vector2i.RIGHT:
			east_wall.disable()
			walls.erase(east_wall)
		Vector2i.DOWN:
			south_wall.disable()
			walls.erase(south_wall)
		Vector2i.LEFT:
			west_wall.disable()
			walls.erase(west_wall)
