extends CharacterBody3D

@export var gravity: float = 65.0
@export var jump_force: float = 12.0
@export var jump_cut_multiplier: float = 0.4
@export var max_jump_time: float = 0.10

var jump_time := 0.0
var is_jumping := false

func _physics_process(delta):
	var jump_pressed = Input.is_action_just_pressed("ui_accept")
	var jump_held = Input.is_action_pressed("ui_accept")
	var jump_released = Input.is_action_just_released("ui_accept")

	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump start
	if jump_pressed and is_on_floor():
		is_jumping = true
		jump_time = 0.0
		velocity.y = jump_force

	# Keep jumping
	if is_jumping and jump_held:
		jump_time += delta
		if jump_time < max_jump_time:
			velocity.y = jump_force
		else:
			is_jumping = false

	# Cut jump when release button
	if is_jumping and jump_released:
		velocity.y *= jump_cut_multiplier
		is_jumping = false

	if velocity.y < 0:
		is_jumping = false

	move_and_slide()
