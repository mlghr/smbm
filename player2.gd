extends CharacterBody2D

var speed = 600
var jump_velocity = -700
var gravity = 1500
var jump_cut_multiplier = 0.6

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement
	var direction = Input.get_axis("move_left2", "move_right2")
	velocity.x = direction * speed

	# Jump start
	if Input.is_action_just_pressed("jump2") and is_on_floor():
		velocity.y = jump_velocity

	# Variable jump height (THIS is the key)
	if Input.is_action_just_released("jump2") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	move_and_slide()
