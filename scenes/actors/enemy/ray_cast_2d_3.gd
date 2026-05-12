extends RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	rotation = -get_parent().rotation

	if get_collider() != null:
		if get_collider().is_in_group("player"):
			print('up')
