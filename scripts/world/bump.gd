extends StaticBody2D

var is_bumping = false
var original_y = 0
var BUMP_RADIUS = 95
var block_midpoint = null
var bump_direction = null # left or right
var is_grumpy = false


func _ready():
	original_y = position.y


func bump(player):
	block_midpoint = global_position.x
	
	if self.is_grumpy:
		bump_grump(player)

	if is_bumping:
		return
	is_bumping = true
	var tween = create_tween()
	tween.tween_property(self, "position:y", original_y - 20, 0.08)
	#bumping player
	var players = get_tree().get_nodes_in_group("player")
	for p in players:
		if not is_same(player, p) and p.has_method("handle_bump_stun"):
			if global_position.distance_to(p.global_position) <= BUMP_RADIUS:
				if p.global_position.x >= block_midpoint:
					bump_direction = "right"
				else:
					bump_direction = "left"
				p.handle_bump_stun(bump_direction)
	#bumping enemyw
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		if global_position.distance_to(e.global_position) <= BUMP_RADIUS + 25:
			e.handle_bump_stun()
			print("bumped enemy")

	tween.tween_property(self, "position:y", original_y, 0.12)

	tween.finished.connect(
		func():
			is_bumping = false
	)
func set_grumpy():
	self.is_grumpy = true;
	$Sprite2D.modulate = Color.RED
	
func bump_grump(player):
	is_grumpy = false
	var start_block = self.golbal_position.x
	var row = self.get_parent().get_children()
	var x_values = []
	for b in row:
		x_values.append(b.global_position.x)
	x_values.sort()
	print(x_values)
	
	
	
	# L R bump
	# if null return
	# else bump L R
	
	
