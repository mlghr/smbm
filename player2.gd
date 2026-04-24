extends CharacterBody2D

var speed = 550
var jump_velocity = -800
var gravity = 1500
var jump_cut_multiplier = 0.6

var standing_on_body = false
var is_dead = false
var death_played = false

func _physics_process(delta):
	if is_dead:
		handle_death()
		return

	apply_gravity(delta)
	handle_input()
	handle_jump()
	move_and_slide()
	handle_collisions()
	handle_screen_wrap()	
	update_animation()

func _process(delta):
	# keep wrap sprite in sync
	$WrapSprite.animation = $AnimatedSprite2D.animation
	$WrapSprite.frame = $AnimatedSprite2D.frame
	$WrapSprite.flip_h = $AnimatedSprite2D.flip_h

# -------------------------
# core systems, inputs, etc.
# -------------------------

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor() and velocity.y > 0:
		velocity.y = 0

func handle_input():
	var direction = Input.get_axis("move_left2", "move_right2")
	velocity.x = lerp(velocity.x, direction * speed, 0.2)

	if direction < 0:
		$AnimatedSprite2D.flip_h = false
	elif direction > 0:
		$AnimatedSprite2D.flip_h = true

func handle_jump():
	if Input.is_action_just_pressed("jump2") and is_on_floor():
		velocity.y = jump_velocity
		$AudioStreamPlayer2D.play()

	if Input.is_action_just_released("jump2") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier

# -------------------------
# animation
# -------------------------

func update_animation():
	if is_on_floor() and abs(velocity.x) > 100:
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")

func handle_death():
	velocity = Vector2.ZERO
	move_and_slide()

	if not death_played:
		death_played = true
		$AnimatedSprite2D.play("Die")

# -------------------------
# collisions
# -------------------------

func handle_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		var normal = collision.get_normal()

		# hit block from below
		if normal.y > 0.9:
			if other.has_method("bump"):
				other.bump()

		# enemy hit
		if other.is_in_group("enemy"):
			print("Enemy hit")
			is_dead = true
			return

		# player interactions
		if other is CharacterBody2D:
			handle_push(collision, other)

func handle_push(collision, other):
	var normal = collision.get_normal()

	# vertical stacking (standing on another player)
	if normal.y < -0.9:
		standing_on_body = true

		if abs(global_position.x - other.global_position.x) < 20:
			global_position.x += other.velocity.x * get_physics_process_delta_time()

			if other.velocity.y < 0 and velocity.y >= 0:
				velocity.y = other.velocity.y

		return

	# side push
	if abs(normal.x) > 0.9:
		if abs(global_position.y - other.global_position.y) < 10:
			var push_dir = sign(global_position.x - other.global_position.x)
			velocity.x += push_dir * 400

# -------------------------
# screen wrap, allows peeking
# -------------------------

func handle_screen_wrap():
	var left_bound = -510
	var right_bound = 510
	var width = right_bound - left_bound

	var sprite_width = 60

	# hide ghost by default
	$WrapSprite.visible = false

	# approaching left edge
	if global_position.x < left_bound + sprite_width:
		$WrapSprite.visible = true
		$WrapSprite.global_position = global_position
		$WrapSprite.global_position.x += width

	# approaching right edge
	elif global_position.x > right_bound - sprite_width:
		$WrapSprite.visible = true
		$WrapSprite.global_position = global_position
		$WrapSprite.global_position.x -= width

	# actual teleport (off-screen)
	if global_position.x < left_bound - sprite_width:
		global_position.x += width
	elif global_position.x > right_bound + sprite_width:
		global_position.x -= width
