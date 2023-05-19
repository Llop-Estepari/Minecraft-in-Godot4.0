extends Node3D

var cube_scn = preload("res://scenes/world/cube.tscn")

@onready var cubes = $Cubes

var h_cells : int = 10
var world_height := 2
var v_cells : int = 10

var array_cubes : Array[Vector3i]

func _ready():
	randomize()
	for y in world_height:
		for h in h_cells:
			for v in v_cells:
				create_cube(Vector3(h, y, v), 0)
				create_cube(Vector3(-h, y, -v), 0)
				create_cube(Vector3(h, y, -v), 0)
				create_cube(Vector3(-h, y, v), 0)
	generate_structure(house)

func create_cube(pos : Vector3i, cube_id : int):
	if pos in array_cubes:
		return
	array_cubes.append(pos)
	var cube = cube_scn.instantiate()
	cubes.add_child(cube)
	cube.init(cube_id)
	cube.position = pos

var house : Array[String] = [
	"X","X","X","X","X","/",
	"X"," "," "," ","X","/",
	"X"," "," "," ","X","/",
	"X"," "," "," ","X","/",
	"X","X","X","X","X","/",
	"X"," "," "," ","X","/",
	"X"," "," "," ","X","/",
	"X","X","X","X","X","/"]

var house_depth = 3

func generate_structure(structure):
	var start_pos = get_random_position()
	var cur_line_array : Array = []
	var depth = house_depth
	for d in depth:
		var h_height = 0
		for line in structure:
			if line == "/":
				create_line(h_height, start_pos + Vector3i(0,0,d), cur_line_array)
				cur_line_array.clear()
				h_height += 1
			else:
				cur_line_array.append(line)

func create_line(height, start_pos, cur_line_array):
	var pos = 0
	for i in cur_line_array:
		if i == "X":
			create_cube(start_pos + Vector3i(pos, height, 0), 1)
		pos += 1

func get_random_position() -> Vector3i:
	return Vector3i(randi_range(-h_cells/2, h_cells/2), world_height, randi_range(-v_cells/2, v_cells/2))


