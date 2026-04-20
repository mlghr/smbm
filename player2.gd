extends CharacterBody2D

var speed = 600
var jump_velocity = -700
var gravity = 1500
var jump_cut_multiplier = 0.6

var is_dead = false
var death_played = false

func _physics_process(delta):

	# death state
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()

		# play death animation only once
		if not death_played:
			death_played = true
			$AnimatedSprite2D.play("Die")

		return

	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor() and velocity.y > 0:
		velocity.y = 0

	# movement
	var direction = Input.get_axis("move_left2", "move_right2")
	velocity.x = lerp(velocity.x, direction * speed, 0.2)

	# flip sprite
	if direction < 0:
		$AnimatedSprite2D.flip_h = false
	elif direction > 0:
		$AnimatedSprite2D.flip_h = true

	# animations (only when alive)
	if is_on_floor() and abs(velocity.x) > 100:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")

	# jump
	if Input.is_action_just_pressed("jump2") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_just_released("jump2") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

	move_and_slide()

	# collisions
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var other = collision.get_collider()

		if other.is_in_group("enemy"):
			is_dead = true
			return

		if other is CharacterBody2D:
			var normal = collision.get_normal()

			if abs(normal.x) > 0.9:
				if abs(global_position.y - other.global_position.y) < 10:
					var push_dir = sign(global_position.x - other.global_position.x)
					velocity.x += push_dir * 400
