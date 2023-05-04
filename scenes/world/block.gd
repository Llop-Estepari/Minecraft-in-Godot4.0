class_name Block
extends StaticBody3D

#birch_log, cobblestone, oka_planks, dirt
var outline_material = preload("res://scenes/world/selected_block.tres")

@onready var cube = $block/Cube

var materials_path = "res://assets/3d_models/enviroment/"

func init(texture):
	cube.set_surface_override_material(0, load(materials_path + list_materials_in_directory(texture)))

func list_materials_in_directory(texture) -> String:
	var dir = DirAccess.open(materials_path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif texture + ".tres" in file:
			dir.list_dir_end()
			return file
	dir.list_dir_end()
	return "null"

func hover():
	cube.material_overlay = outline_material

func unhover():
	cube.material_overlay = null
