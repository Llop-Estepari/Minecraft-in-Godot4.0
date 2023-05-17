class_name Block
extends StaticBody3D

var destroy_shader = preload("res://assets/3d_models/enviroment/destroy_material.tres").duplicate()

#Destruction labels
@onready var cube : MeshInstance3D = $CubeMesh
@onready var destroy_mesh : MeshInstance3D = $DestroyMesh

var outline_material  : StandardMaterial3D = preload("res://scenes/world/selected_block.tres")
var item_drop_scn : PackedScene = preload("res://scenes/world/items/item_drop.tscn")

var cube_id : int = 0
var hardness : float = 100.0
var destroy = 0.0: set = _set_destroy

func _set_destroy(value):
	destroy += value
	if destroy == 0.0: 
		destroy_mesh.set_surface_override_material(0, null)
	elif destroy > 1.0 and destroy < hardness * 33 / 100:
		destroy_shader.albedo_texture = load("res://assets/3d_models/enviroment/destroy_phase0.png")
		destroy_mesh.set_surface_override_material(0, destroy_shader)
	elif destroy > hardness * 33 / 100 and destroy < hardness * 66 / 100:
		destroy_shader.albedo_texture = load("res://assets/3d_models/enviroment/destroy_phase1.png")
		destroy_mesh.set_surface_override_material(0, destroy_shader)
	elif destroy > hardness * 66 / 100 and destroy < hardness:
		destroy_shader.albedo_texture = load("res://assets/3d_models/enviroment/destroy_phase2.png")
		destroy_mesh.set_surface_override_material(0, destroy_shader)
	
	if destroy >= hardness:
		destroy_block()

func init(id):
	cube_id = id
	set_cube()

func set_cube():
	hardness = Items.items_list[cube_id][7]
	cube.set_surface_override_material(0, load(Items.items_list[cube_id][5]))

func hover():
	cube.material_overlay = outline_material

func unhover():
	cube.material_overlay = null

func reset_destroy():
	destroy = 0.0

func destroy_block():
	var item_drop = item_drop_scn.instantiate()
	get_tree().get_root().add_child(item_drop)
	item_drop.init(cube_id, position)
	queue_free()
