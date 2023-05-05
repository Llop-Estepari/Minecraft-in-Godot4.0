class_name Block
extends StaticBody3D

@onready var info = $info

#birch_log, cobblestone, oka_planks, dirt, birch_leaves
var outline_material = preload("res://scenes/world/selected_block.tres")
var item_drop_scn = preload("res://scenes/world/item_drop.tscn")

var materials_path = "res://assets/3d_models/enviroment/"

@onready var cube = $block/Cube
var material = null

@export var item_to_drop : PackedScene
@export var amount_to_drop : int = 1
@export var max_destroy : float = 100.0

var destroy = 0.0: set = _set_destroy

func _set_destroy(value):
	destroy += value
	for l in info.get_children():
		l.text = str(destroy)
	if destroy >= max_destroy:
		destroy_block()

func init(texture):
	if texture == "cobblestone": max_destroy = 200.0
	material = load(materials_path + list_materials_in_directory(texture))
	cube.set_surface_override_material(0, material)

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

func reset_destroy():
	_set_destroy(0.0)

func destroy_block():
	var item_drop = item_drop_scn.instantiate()
	get_tree().get_root().add_child(item_drop)
	item_drop.init(material, amount_to_drop, position)
	queue_free()
