extends CharacterBody2D

# at 300 speed he hits wall, aggresive speed?
const SPEED = 50
const GRAVITY = 500
var direction = 1

var closest_player = null
var closest_distance = INF
var is_stunned = false
var stun_played = false
var is_on_ground = true

# distances for player tracking
var dx = 0
var dy = 0


func _physics_process(delta):
	if is_stunned:
		handle_stunned()
		return

	apply_gravity(delta)
	move_enemy()
	move_and_slide()
	handle_collisions()
	handle_screen_wrap()
	find_closest_player()
	update_animation()


func _process(delta):
	# keep wrap sprite in sync
	$WrapSprite.animation = $AnimatedSprite2D.animation
	$WrapSprite.frame = $AnimatedSprite2D.frame
	$WrapSprite.flip_h = $AnimatedSprite2D.flip_h

# -------------------------
# movement
# -------------------------


func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta


func move_enemy():
	velocity.x = direction * SPEED

# -------------------------
# collisions (wall turn)
# -------------------------


func handle_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()
		var other = collision.get_collider()

		# turn around on wall hit
		if abs(normal.x) > 0.9:
			direction *= -1
			$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h

		if other.is_in_group("player"):
			other.is_dead = true
			is_stunned = true
			$CollisionShape2D.disabled = true

# -------------------------
# player tracking
# -------------------------


func find_closest_player():
	var players = get_tree().get_nodes_in_group("player")

	closest_player = null
	closest_distance = INF

	for p in players:
		var distance = global_position.distance_to(p.global_position)

		if distance < closest_distance:
			closest_distance = distance
			closest_player = p

	# compute x/y distance AFTER closest is found
	if closest_player:
		dx = abs(global_position.x - closest_player.global_position.x)
		dy = abs(global_position.y - closest_player.global_position.y)

# -------------------------
# animation
# -------------------------


func update_animation():
	# use x + y proximity instead of circular distance
	$AnimatedSprite2D.play("Walk")


func handle_stunned():
	velocity = Vector2.ZERO
	move_and_slide()

	#if not stun_played:
	#stun_played = true
	#$AnimatedSprite2D.play("Die")


func handle_screen_wrap():
	var left_bound = -128
	var right_bound = 128
	var width = right_bound - left_bound

	var sprite_width = 16

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


func handle_bump_stun():
	is_on_ground = false
	is_stunned = true
	velocity.y = -300
	velocity.x = 0


func teleport_to(target: Node2D):
	global_position = target.global_position
	velocity = Vector2.ZERO
