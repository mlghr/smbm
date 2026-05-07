extends RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	global_rotation = deg_to_rad(90)

	if get_collider() != null:
		if get_collider().is_in_group("player"):
			print("right")
			if get_parent().is_stomped:
				get_parent().is_stomped = false
				get_parent().direction = 1
