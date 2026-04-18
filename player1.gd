extends CharacterBody2D

var speed = 600
var jump_velocity = -700
var gravity = 1500
var jump_cut_multiplier = 0.6

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta	
	
	if is_on_floor() && abs(velocity.x) > 100:
		$AnimatedSprite2D.play("Run")
	else: $AnimatedSprite2D.play("Idle")
	
	# Horizontal movement
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = lerp(velocity.x, direction * speed, 0.2)

	if direction < 0:
		$AnimatedSprite2D.flip_h = false
	if direction > 0:
		$AnimatedSprite2D.flip_h = true
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Variable jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier
	
	move_and_slide()
	
	# Push logic
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var other = collision.get_collider()

		if other is CharacterBody2D:
			var push_dir = sign(global_position.x - other.global_position.x)
			velocity.x += push_dir * 800
