extends StaticBody2D

var is_bumping = false
var original_y = 0

func _ready():
	original_y = position.y

func bump():
	if is_bumping:
		return
	
	is_bumping = true

	var tween = create_tween()
	tween.tween_property(self, "position:y", original_y - 20, 0.08)
	tween.tween_property(self, "position:y", original_y, 0.12)

	tween.finished.connect(func():
		is_bumping = false
	)
