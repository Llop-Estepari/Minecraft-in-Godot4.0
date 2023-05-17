extends CharacterBody3D

@onready var arm_animation_player : AnimationPlayer = $Head/Arm_AnimationPlayer

@onready var jump_cd : Timer = $Timers/jump_cd
@onready var destroy_cd : Timer = $Timers/destroy_cd

@onready var head : Node3D = $Head
@onready var range_raycast : RayCast3D = $Head/Camera3D/range_raycast
@onready var arm_handler : Node3D = $Head/arm_handler
@onready var hud : CanvasLayer = $HUD

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const SPEED = 3.0
const RUN_SPEED = 7.0
const JUMP_VELOCITY = 10.0

var cur_speed = SPEED
var direction
var can_jump := true

var mouse_sens = 0.1

var cur_cube
var can_destroy := true
#Left mouse pressed
var jump_action := false
var destroy_action := false

var cur_slot : int
var inventory : Array[Array] = [[-1, 0],[-1, 0],[-1, 0],[-1, 0],[-1, 0],[-1, 0],[-1, 0],[-1, 0],[-1, 0]]
var max_slots : int = 64

var exp_lvl : int = 0
var exp_amnt : int : set = _set_exp_amnt

func _set_exp_amnt(amount):
	exp_amnt += amount
	if exp_amnt == 100:
		exp_lvl += 1
		exp_amnt = 0
	hud.set_new_exp_value(exp_amnt)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	input_camera_movement(event)
	inventory_controller()
	input_actions()

func input_camera_movement(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		head.rotation_degrees.x -= mouse_sens * event.relative.y
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)

func input_actions():
	destroy_action = Input.is_action_pressed("action_destroy")
	jump_action = Input.is_action_pressed("action_jump")
	
	if Input.is_action_just_pressed("action_esc"): get_tree().quit()
	if destroy_action and can_destroy:
		can_destroy = false
		destroy_cd.start()
	
	if Input.is_action_pressed("action_sprint") and Input.get_axis("forward", "backward") != 0 and not destroy_action:
		arm_animation_player.speed_scale = 1.5
		cur_speed = RUN_SPEED
	else:
		cur_speed = SPEED
		arm_animation_player.speed_scale = 1.0

func inventory_controller():
	if Input.is_key_pressed(KEY_1): switch_slot(0)
	elif Input.is_key_pressed(KEY_2): switch_slot(1)
	elif Input.is_key_pressed(KEY_3): switch_slot(2)
	elif Input.is_key_pressed(KEY_4): switch_slot(3)
	elif Input.is_key_pressed(KEY_5): switch_slot(4)
	elif Input.is_key_pressed(KEY_6): switch_slot(5)
	elif Input.is_key_pressed(KEY_7): switch_slot(6)
	elif Input.is_key_pressed(KEY_8): switch_slot(7)
	elif Input.is_key_pressed(KEY_9): switch_slot(8)
	if Input.is_action_just_pressed("action_slot_up"): switch_slot(cur_slot+1)
	elif Input.is_action_just_pressed("action_slot_down"): switch_slot(cur_slot-1)

func switch_slot(slot : int):
	if slot == 9: cur_slot = 0
	elif slot < 0: cur_slot = 8
	else: cur_slot = slot
	
	arm_handler.switch_slot_to(cur_slot)
	hud.switch_slot_to()

func _physics_process(delta):
	cube_controller()
	movement(delta)
	animation_controller()

func animation_controller():
	if destroy_action:
		arm_animation_player.play("destroy")
	elif direction and is_on_floor():
		arm_animation_player.play("walk_movement")
	else:
		arm_animation_player.play("idle")

func movement(delta):
	if not is_on_floor(): velocity.y -= gravity * delta
	
	if jump_action and is_on_floor() and can_jump:
		can_jump = false
		jump_cd.start()
		velocity.y = JUMP_VELOCITY
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			velocity.x = direction.x * cur_speed
			velocity.z = direction.z * cur_speed
		else:
			velocity.z = lerp(velocity.z, direction.z * cur_speed, .1)
			velocity.x = lerp(velocity.x, direction.x * cur_speed, .1)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, cur_speed)
			velocity.z = move_toward(velocity.z, 0, cur_speed)
	
	move_and_slide()

func cube_controller():
	if range_raycast.get_collider() is Block:
		if cur_cube != null: cur_cube.unhover()
		cur_cube = range_raycast.get_collider()
		cur_cube.hover()
	else:
		if cur_cube != null:
			cur_cube.unhover()
			cur_cube.reset_destroy()
			cur_cube = null

func try_destroy():
	if cur_cube != null:
		cur_cube._set_destroy(25)

func _on_item_area_area_entered(area):
	var item = area.get_parent()
	find_suitable_slot(item)
	_set_exp_amnt(25)

func find_suitable_slot(new_item):
	for slot in inventory.size():
		if inventory[slot][0] == new_item._get_item_id() or inventory[slot][0] == -1:
			if inventory[slot][0] == -1: inventory[slot][0] = new_item._get_item_id()
			if inventory[slot][1] < max_slots: add_items_to_inventory_slot(slot, new_item)
		if new_item._get_amount() <= 0:
			break

func add_items_to_inventory_slot(slot, item):
	while item._get_amount() > 0:
		if inventory[slot][1] == max_slots:
			return
		inventory[slot][1] += 1
		item.pickup_item()
		arm_handler.switch_mesh(item._get_item_id(), slot)
		hud.add_item_to_inventory(slot, inventory[slot][1])
		

func _on_jump_cd_timeout():
	can_jump = true

func _on_destroy_cd_timeout():
	can_destroy = true
