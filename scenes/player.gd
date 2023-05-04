extends CharacterBody3D

@onready var head = $Head
@onready var arm_animation_player = $Head/Arm_AnimationPlayer
@onready var range_raycast : RayCast3D = $Head/Camera3D/range_raycast
@onready var jump_cd = $Timers/jump_cd

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
const SPEED = 4.0
const RUN_SPEED = 7.0
const JUMP_VELOCITY = 10.0

var cur_speed = SPEED
var direction
var can_jump := true

var mouse_sens = 0.1

var cur_block
#Left mouse pressed
var destroying := false
var jump_action := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		head.rotation_degrees.x -= mouse_sens * event.relative.y
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)
	
	if Input.is_action_pressed("action_sprint") and Input.get_axis("forward", "backward") != 0:
		arm_animation_player.speed_scale = 1.5
		cur_speed = RUN_SPEED
	else:
		cur_speed = SPEED
		arm_animation_player.speed_scale = 1.0
	
	destroying = Input.is_action_pressed("destroy_action")
	jump_action = Input.is_action_pressed("action_jump")

func _physics_process(delta):
	#DEBUG
	$HUD/Label.text = str(range_raycast.get_collider()) + str("\n", is_on_floor())
	if Input.is_action_just_pressed("action_esc"): get_tree().quit()
	#
	
	block_controller()
	
	movement(delta)
	animation_controller()

func animation_controller():
	if destroying:
		arm_animation_player.play("interact")
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

func block_controller():
	if range_raycast.get_collider() is Block:
		if cur_block != null: cur_block.unhover()
		cur_block = range_raycast.get_collider()
		cur_block.hover()
		if destroying:
			cur_block._set_destroy(5)
	else:
		if cur_block != null:
			cur_block.unhover()
			cur_block.reset_destroy()


func _on_jump_cd_timeout():
	can_jump = true
