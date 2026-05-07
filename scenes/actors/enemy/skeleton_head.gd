extends RigidBody2D

const GRAVITY = 1500
var speed = 300




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity.x = speed
	#TODO: make actual method that is called when skull is bumped to initially call.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta):
	apply_gravity(delta)
	handle_collisions()
	handle_screen_wrap()
	linear_velocity.x = speed

func apply_gravity(delta):
	linear_velocity.y += GRAVITY * delta

func handle_collisions():
	return

func handle_screen_wrap():
	var left_bound = -540
	var right_bound = 540
	var width = right_bound - left_bound

	var sprite_width = 60

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
