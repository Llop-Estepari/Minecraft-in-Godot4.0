extends CharacterBody3D

@onready var area_3d = $Area3D
@onready var mesh_instance_3d = $MeshInstance3D

var mesh = preload("res://assets/3d_models/enviroment/block_mesh.res").duplicate()
var item_content : String = "": set = _set_itemContent, get = _get_itemContent

func _get_itemContent(): return item_content

func _set_itemContent(newitemContent): item_content = newitemContent

var amount : int = 1: set = _set_amount, get = _get_amount

func _get_amount(): return amount

func _set_amount(value): amount = value

func init(item_to_drop, material : StandardMaterial3D, amnt, pos, new_mesh = mesh):
	item_content = item_to_drop
	amount = amnt
	new_mesh.surface_set_material(0, material)
	mesh_instance_3d.mesh = mesh
	position = pos

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= 15.0 * delta
	velocity.y = clamp(velocity.y, -30.0, 30.0)
	move_and_slide()

func pickup_item() -> Mesh:
	amount -= 1
	if amount == 0: queue_free()
	return mesh
