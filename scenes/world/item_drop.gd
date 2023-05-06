extends CharacterBody3D

var itemContent : String = "": set = _set_itemContent, get = _get_itemContent

var test = "oka_planks"

func _get_itemContent():
	return itemContent

func _set_itemContent(newitemContent):
	itemContent = newitemContent

@onready var mesh_instance_3d = $MeshInstance3D
var mesh = preload("res://assets/3d_models/enviroment/block_mesh.res").duplicate()
var amount : int

func init(material, amnt, pos):
	amount = amnt
	mesh_instance_3d.set_surface_override_material(0, material)
	position = pos

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 15.0 * delta
	velocity.y = clamp(velocity.y, -30.0, 30.0)
	move_and_slide()
