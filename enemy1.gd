extends CharacterBody2D

const SPEED = 300.0
var gravity = 1500
var direction = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	#
	#if is_on_floor() and abs(velocity.x) > 100:
		#$AnimatedSprite2D.play("Walk")
	#else:
		#$AnimatedSprite2D.play("Idle")
	#
	## use direction
	#velocity.x = direction * SPEED
	#
	#move_and_slide()
	#
	#for i in range(get_slide_collision_count()):
		#var collision = get_slide_collision(i)
		#var normal = collision.get_normal()
#
		## turn around on wall hit
		#if abs(normal.x) > 0.9:
			#direction *= -1
			#$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
