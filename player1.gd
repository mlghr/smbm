extends CharacterBody2D

var speed = 600
var jump_velocity = -625
var gravity = 1250

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Left/right movement
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
