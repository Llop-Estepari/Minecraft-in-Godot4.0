extends Node3D

var block_scn = preload("res://scenes/world/block.tscn")

@onready var blocks = $blocks

var h_cells : int = 5
var world_height := 2
var v_cells : int = 5

var array_blocks : Array[Vector3i]

func _ready():
	randomize()
	for y in world_height:
		for h in h_cells:
			for v in v_cells:
				create_block(Vector3(h, y, v), "dirt")
				create_block(Vector3(-h, y, -v), "dirt")
	generate_structure(house)

func create_block(pos : Vector3i, texture: String):
	if pos in array_blocks:
		return
	array_blocks.append(pos)
	var block = block_scn.instantiate()
	blocks.add_child(block)
	block.init(texture)
	block.position = pos

var house : Array[String] = [
	"X","X"," ","X","X","/",
	"X","X"," ","X","X","/",
	"X","X","X","X","X","/",
	" ","X","X","X"," ","/",
	" "," ","X"," "," ","/",]

var house_depth = 6

func generate_structure(structure):
	var start_pos = get_random_position()
	var cur_line_array : Array = []
	var depth = house_depth
	for d in depth:
		var h_height = 0
		for line in structure:
			if line == "/":
				create_line(h_height, start_pos + Vector3(0,0,d), cur_line_array)
				cur_line_array.clear()
				h_height += 1
			else:
				cur_line_array.append(line)

func create_line(height, start_pos, cur_line_array):
	var pos = 0
	for i in cur_line_array:
		if i == "X":
			create_block(start_pos + Vector3(pos, height, 0), "cobblestone")
		pos += 1

func get_random_position() -> Vector3:
	return Vector3(randi_range(-h_cells/2, h_cells/2), world_height, randi_range(-v_cells/2, v_cells/2))


