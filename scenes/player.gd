extends CharacterBody3D

@onready var head = $Head
@onready var arm_animation_player = $Head/Arm_AnimationPlayer
@onready var range_raycast : RayCast3D = $Head/Camera3D/range_raycast

const SPEED = 7.0
const RUN_SPEED = 10.0
const JUMP_VELOCITY = 14.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var cur_speed = SPEED

var mouse_sens = 0.1
var direction

var cur_block

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

func _physics_process(delta):
	#DEBUG
	if Input.is_action_just_pressed("action_esc"): get_tree().quit()
	#
	
	block_controller()
	
	movement(delta)
	animation_controller()

func animation_controller():
	if direction and is_on_floor():
		if not arm_animation_player.is_playing(): arm_animation_player.play("walk_movement")
	else:
		arm_animation_player.play("idle")
	
func movement(delta):
	if not is_on_floor(): velocity.y -= gravity * delta
	
	if Input.is_action_pressed("action_jump") and is_on_floor(): velocity.y = JUMP_VELOCITY
	
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
	else:
		if cur_block != null: cur_block.unhover()
