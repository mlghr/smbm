extends CharacterBody2D

var speed = 350
var jump_velocity = -905
const gravity = 1500
var jump_cut_multiplier = 0.6
const NORMAL_CONTROL = 0.2
const SLIDE_CONTROL = 0.04
const PLAYER_BUMP_FORCE = 420.0
const PLAYER_BUMP_COOLDOWN = 0.15
const PLAYER_BUMP_SLIDE_TIME = 0.25

var standing_on_body = false
var death_played = false
var is_dead = false
# allows manual changing of state for stuns
var is_on_ground = true
var is_stunned = false
var bump_slide_time_left = 0.0
var last_player_bump_time = -10.0
var carried_velocity = Vector2.ZERO


func _physics_process(delta):
	if is_dead:
		handle_death()
		return

	# Apply carry from a player underneath us from the previous frame.
	# This lets the lower player move/jump freely while still carrying the upper one.
	if carried_velocity != Vector2.ZERO:
		global_position += carried_velocity * delta
	carried_velocity = Vector2.ZERO
	standing_on_body = false

	apply_gravity(delta)
	if bump_slide_time_left > 0.0:
		bump_slide_time_left = max(0.0, bump_slide_time_left - delta)
	handle_input()
	handle_jump()
	handle_dash()
	move_and_slide()
	is_on_ground = is_on_floor()
	handle_collisions()
	handle_screen_wrap()
	update_animation()


func _process(_delta):
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
		if velocity.y > 0:
			velocity.y = (velocity.y * velocity.y) / (velocity.y * .92)
			pass

	if is_on_floor() and velocity.y > 0:
		velocity.y = 0


func handle_input():
	var direction = Input.get_axis("move_left2", "move_right2")
	var control = NORMAL_CONTROL
	if bump_slide_time_left > 0.0:
		control = SLIDE_CONTROL

	if not is_stunned:
		velocity.x = lerp(velocity.x, direction * speed, control)

		if direction < 0:
			$AnimatedSprite2D.flip_h = false
		elif direction > 0:
			$AnimatedSprite2D.flip_h = true


func handle_jump():
	if Input.is_action_just_pressed("jump2") and is_on_ground and not is_stunned:
		velocity.y = jump_velocity
		$AudioStreamPlayer2D.play()

	if Input.is_action_just_released("jump2") and velocity.y < 0:
		velocity.y *= jump_cut_multiplier


func handle_dash():
	if Input.is_action_just_pressed("dash"):
		velocity.x = velocity.x * 3
		$AudioStreamPlayer2D.play()

# -------------------------
# animation
# -------------------------


func update_animation():
	if is_stunned:
		$AnimatedSprite2D.play("Stun")
		return

	if is_on_floor() and abs(velocity.x) > 100:
		$AnimatedSprite2D.play("Run")
		return

	else:
		$AnimatedSprite2D.play("Idle")


func handle_death():
	velocity = Vector2.ZERO
	move_and_slide()

	if not death_played:
		death_played = true
		$CollisionShape2D.disabled = true
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
				other.bump(self)

		# enemy hit
		if other.is_in_group("enemy"):
			is_dead = true
			return

		# player interactions
		if other.is_in_group("player"):
			handle_push(collision, other)


func handle_push(collision, other):
	var normal = collision.get_normal()

	# vertical stacking (standing on another player)
	if normal.y < -0.9:
		standing_on_body = true

		# Ride the player underneath like a moving platform.
		if abs(global_position.x - other.global_position.x) < 24:
			carried_velocity.x = other.velocity.x

		# If the bottom player jumps up into us, keep us attached so we don't "pin" them.
		if other.velocity.y < 0 and velocity.y >= 0:
			velocity.y = other.velocity.y
		return

	# Someone is standing on us: explicitly pass our motion up to them.
	if normal.y > 0.9:
		if other.has_method("receive_carrier_motion"):
			other.receive_carrier_motion(velocity, get_physics_process_delta_time())
		return

	# side push
	if abs(normal.x) > 0.9:
		if abs(global_position.y - other.global_position.y) < 10:
			var now = Time.get_ticks_msec() / 1000.0
			if now - last_player_bump_time < PLAYER_BUMP_COOLDOWN:
				return

			var push_dir = sign(global_position.x - other.global_position.x)
			if push_dir == 0:
				push_dir = sign(-normal.x)

			apply_player_bump(push_dir)
			if other.has_method("apply_player_bump"):
				other.apply_player_bump(-push_dir)


func apply_player_bump(push_dir):
	last_player_bump_time = Time.get_ticks_msec() / 1000.0
	bump_slide_time_left = PLAYER_BUMP_SLIDE_TIME
	velocity.x = push_dir * PLAYER_BUMP_FORCE


func receive_carrier_motion(carrier_velocity, delta):
	# Immediate follow keeps stacked colliders from pinning the carrier.
	global_position.x += carrier_velocity.x * delta
	carried_velocity.x = carrier_velocity.x
	# Match carrier horizontal motion so rider damping does not drag the bottom player.
	# Keep player agency by blending in local input so they can walk/jump off.
	var direction = Input.get_axis("move_left2", "move_right2")
	velocity.x = carrier_velocity.x + direction * speed * 0.75
	if carrier_velocity.y < 0:
		global_position.y += carrier_velocity.y * delta
		carried_velocity.y = carrier_velocity.y
		if velocity.y >= carrier_velocity.y:
			velocity.y = carrier_velocity.y


func handle_bump_stun(bump_direction):
	is_on_ground = false
	is_stunned = true
	velocity.y = -400
	velocity.x = 0

	if bump_direction == "left":
		velocity.x = randi_range(90, 250)
		print(velocity.x)
	else:
		velocity.x = randi_range(90, 250)
		print(velocity.x)

	$AnimatedSprite2D.play("Stun")
	await get_tree().create_timer(0.5).timeout
	is_stunned = false


# -------------------------
# screen wrap, allows peeking
# -------------------------
func handle_screen_wrap():
	var left_bound = -540
	var right_bound = 540
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
