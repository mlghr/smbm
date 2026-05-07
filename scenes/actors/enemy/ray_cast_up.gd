extends RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	global_rotation = deg_to_rad(180)

	if get_collider() != null:
		if get_collider().is_in_group("player"):
			print('up')
			get_parent().handle_head_stomp()
