extends CharacterBody2D

const SPEED = 300.0
var gravity = 1500
var direction = 1

var closest_player = null
var closest_distance = INF

# distances for player tracking
var dx = 0
var dy = 0

func _physics_process(delta):
	apply_gravity(delta)
	move_enemy()
	move_and_slide()
	handle_collisions()
	find_closest_player()
	update_animation()

# -------------------------
# movement
# -------------------------

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

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
	if closest_player and dx < 200 and dy < 80:
		if $AnimatedSprite2D.animation != "Attack":
			$AnimatedSprite2D.play("Attack")
		return

	if is_on_floor() and abs(velocity.x) > 100:
		if $AnimatedSprite2D.animation != "Walk":
			$AnimatedSprite2D.play("Walk")
	else:
		if $AnimatedSprite2D.animation != "Idle":
			$AnimatedSprite2D.play("Idle")

func teleport_to(target: Node2D):
	global_position = target.global_position
	velocity = Vector2.ZERO
