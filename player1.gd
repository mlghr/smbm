extends CharacterBody2D

var speed = 600
var jump_velocity = -700
var gravity = 1500
var jump_cut_multiplier = 0.6

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Stop downward velocity when grounded (prevents bounce)
	if is_on_floor() and velocity.y > 0:
		velocity.y = 0

	# Horizontal movement (smoothed)
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = lerp(velocity.x, direction * speed, 0.2)

	# Flip sprite
	if direction < 0:
		$AnimatedSprite2D.flip_h = false
	elif direction > 0:
		$AnimatedSprite2D.flip_h = true

	# Animations
	if is_on_floor() and abs(velocity.x) > 100:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Variable jump height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	move_and_slide()

	# Push other players (side collisions only)
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var other = collision.get_collider()

		if other is CharacterBody2D:
			var normal = collision.get_normal()

			# Only push on side collisions
			if abs(normal.x) > 0.9:
				# Optional: ignore vertical stacking edge cases
				if abs(global_position.y - other.global_position.y) < 10:
					var push_dir = sign(global_position.x - other.global_position.x)
					velocity.x += push_dir * 400