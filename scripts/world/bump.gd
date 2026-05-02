extends StaticBody2D

var is_bumping = false
var original_y = 0
var BUMP_RADIUS = 95
var block_midpoint = null
var bump_direction = null # left or right
var is_grumpy = false
var current_blocks = []


func _ready():
	original_y = position.y


func bump(player):
	block_midpoint = global_position.x

	if self.is_grumpy:
		bump_grump(player)
		self.is_grumpy = false
		$Sprite2D.modulate = Color8(48, 156, 251)

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
	#bumping enemy
	var enemies = get_tree().get_nodes_in_group("enemy")
	for e in enemies:
		if global_position.distance_to(e.global_position) <= BUMP_RADIUS + 25:
			e.handle_bump_stun()

	tween.tween_property(self, "position:y", original_y, 0.12)

	tween.finished.connect(
		func():
			is_bumping = false
	)


func set_grumpy(blocks):
	self.is_grumpy = true
	$Sprite2D.modulate = Color.RED
	current_blocks = blocks


# create a tidal wave of destruction when a player hits the grumpy bumpy
func bump_grump(player):
	var row = get_parent().get_children()

	# sort blocks by x
	row.sort_custom(
		func(a, b):
			return a.global_position.x < b.global_position.x
	)

	var start_index = row.find(self)

	# spread right
	for i in range(start_index + 1, row.size()):
		var delay = (i - start_index) * 0.20
		trigger_bump_with_delay(row[i], player, delay)

	# spread left
	for j in range(start_index - 1, -1, -1):
		var delay = (start_index - j) * 0.20
		trigger_bump_with_delay(row[j], player, delay)

	var block_count = current_blocks.size()
	if current_blocks.size() > 0:
		var index: int = randi_range(0, current_blocks.size() - 1)
		if current_blocks[index].has_method("set_grumpy"):
			current_blocks[index].set_grumpy(current_blocks)


func trigger_bump_with_delay(block, player, delay):
	var tween = create_tween()
	tween.tween_interval(delay)
	tween.tween_callback(
		func():
			if block.has_method("bump"):
				block.bump(player)
	)
