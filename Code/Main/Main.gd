extends Node
class_name Main

const MAZE = preload("res://Maze/Maze.tscn")

var maze: Maze
var maze_dimensions: Vector2i = Vector2i(2, 2)
var await_time: float = 1.1

func _ready() -> void:
	GenerateMaze(maze_dimensions)

## Level dificulty?
func NextMaze():
	maze_dimensions.x += 1
	maze_dimensions.y += 1
	GenerateMaze(maze_dimensions)

func GenerateMaze(dimensions: Vector2i):
	if maze != null:
		maze.queue_free()
		await get_tree().create_timer(await_time).timeout
	
	maze = MAZE.instantiate()
	maze.main = self
	add_child(maze)
	maze.Generate(dimensions)
