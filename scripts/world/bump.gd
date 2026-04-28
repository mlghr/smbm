extends StaticBody2D

var is_bumping = false
var original_y = 0
var BUMP_RADIUS = 95

func _ready():
	original_y = position.y

func bump(player):
	if is_bumping:
		return
	
	is_bumping = true
	var tween = create_tween()
	tween.tween_property(self, "position:y", original_y - 20, 0.08)
	
	var players = get_tree().get_nodes_in_group("player")
	for p in players:
		if not is_same(player, p) and p.has_method("handle_bump_stun"):
			if global_position.distance_to(p.global_position) <= BUMP_RADIUS:
				p.handle_bump_stun()				
	tween.tween_property(self, "position:y", original_y, 0.12)

	tween.finished.connect(func():
		is_bumping = false
	)
