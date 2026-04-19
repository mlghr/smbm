extends CharacterBody2D

const SPEED = 300.0
var gravity = 1500

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() && abs(velocity.x) > 100:
		$AnimatedSprite2D.play("Walk")
	else: $AnimatedSprite2D.play("Idle")
	
	velocity.x = 200
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var other = collision.get_collider()

		if other is CharacterBody2D:
			var push_dir = sign(global_position.x - other.global_position.x)
			velocity.x += push_dir * 600
