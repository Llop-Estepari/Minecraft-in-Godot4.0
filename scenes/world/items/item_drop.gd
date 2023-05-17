extends CharacterBody3D

@onready var mesh_instance_3d = $Graphics/CubeMesh

var spawned := true
var h_spawn_velocity := 100.0
var v_spawn_velocity := 300.0

var item_id : int: get = _get_item_id
func _get_item_id(): return item_id

var amount : int = 1: get = _get_amount
func _get_amount(): return amount

func init(_item_id, pos):
	item_id = _item_id
	mesh_instance_3d.mesh = load(Items.items_list[_item_id][6]).duplicate()
	mesh_instance_3d.mesh.surface_set_material(0, load(Items.items_list[_item_id][5]))
	position = pos

func _physics_process(delta):
	if spawned:
		velocity.y = v_spawn_velocity * delta * randf_range(0.8, 1.2)
		velocity.x = h_spawn_velocity * delta * randf_range(0.1, 1.1)
		velocity.z = h_spawn_velocity * delta * randf_range(0.1, 1.0)
		spawned = false
	if not is_on_floor():
		velocity.y -= 15.0 * delta
	velocity.x = move_toward(velocity.x, 0.0, 2.5 * delta)
	velocity.z = move_toward(velocity.z, 0.0, 2.5 * delta)
	velocity.y = clamp(velocity.y, -30.0, 30.0)
	rotate_y(1.0 * delta)
	if is_on_floor():
		$Graphics/ShadowMesh.show()
	move_and_slide()

func pickup_item() -> Mesh:
	amount -= 1
	if amount == 0: queue_free()
	return load(Items.items_list[item_id][6])
