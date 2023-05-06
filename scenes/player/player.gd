extends CharacterBody3D

signal item_selected(slot_pos)

@onready var arm_animation_player : AnimationPlayer = $Head/Arm_AnimationPlayer

@onready var jump_cd : Timer = $Timers/jump_cd
@onready var destroy_cd : Timer = $Timers/destroy_cd

@onready var head = $Head
@onready var range_raycast : RayCast3D = $Head/Camera3D/range_raycast

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

var inventory : Array[Array] = [[],[],[],[],[],[],[],[],[],[]]


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
	
	if Input.is_action_pressed("action_sprint") and Input.get_axis("forward", "backward") != 0:
		arm_animation_player.speed_scale = 1.5
		cur_speed = RUN_SPEED
	else:
		cur_speed = SPEED
		arm_animation_player.speed_scale = 1.0
		

func inventory_controller():
	if Input.is_key_pressed(KEY_1): emit_signal("item_selected", 0)
	elif Input.is_key_pressed(KEY_2): emit_signal("item_selected", 1)
	elif Input.is_key_pressed(KEY_3): emit_signal("item_selected", 2)
	elif Input.is_key_pressed(KEY_4): emit_signal("item_selected", 3)
	elif Input.is_key_pressed(KEY_5): emit_signal("item_selected", 4)
	elif Input.is_key_pressed(KEY_6): emit_signal("item_selected", 5)
	elif Input.is_key_pressed(KEY_7): emit_signal("item_selected", 6)
	elif Input.is_key_pressed(KEY_8): emit_signal("item_selected", 7)
	elif Input.is_key_pressed(KEY_9): emit_signal("item_selected", 8)
	if Input.is_action_just_pressed("action_slot_up"): emit_signal("item_selected", -1)
	elif Input.is_action_just_pressed("action_slot_down"): emit_signal("item_selected", -2)

func _physics_process(delta):
	#DEBUG
	$HUD/Label.text = str(range_raycast.get_collider()) + str("\n", is_on_floor())
	#
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

func _on_jump_cd_timeout():
	can_jump = true

func _on_destroy_cd_timeout():
	can_destroy = true
