extends RigidBody2D

const GRAVITY = 1500
var speed = 150
var direction = 1
var is_stomped = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity.x = speed * direction
	#TODO: make actual method that is called when skull is bumped to initially call.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta):
	apply_gravity(delta)
	handle_collisions()
	handle_screen_wrap()
	update_animation()

	if not is_stomped:
		linear_velocity.x = speed * direction


func apply_gravity(delta):
	linear_velocity.y += GRAVITY * delta


func handle_collisions():
	return


func handle_screen_wrap():
	var left_bound = -128
	var right_bound = 128
	var width = right_bound - left_bound

	var sprite_width = 16

	# hide ghost by default
	#$WrapSprite.visible = false

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


func handle_head_stomp():
	is_stomped = true
	linear_velocity.x = 0


func update_animation():
	if not is_stomped:
		$AnimatedSprite2D.play("Roll")
		$WrapSprite.play("Roll")
	else:
		$AnimatedSprite2D.play("default")
		$WrapSprite.play("default")

	handle_sprite_flip()


func handle_sprite_flip():
	if direction < 1:
		$AnimatedSprite2D.flip_h = true
		$WrapSprite.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		$WrapSprite.flip_h = false
