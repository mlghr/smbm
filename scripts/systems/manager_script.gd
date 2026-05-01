extends Node2D

@onready var skeleton_scene = preload("res://scenes/actors/enemy/skeleton.tscn")
@onready var slime_scene = preload("res://scenes/actors/enemy/slime.tscn")
@onready var sandbag_scene = preload("res://scenes/actors/enemy/sandbag.tscn")
@onready var spawn_points = $SpawnPoints.get_children()
@onready var transfer_points = $TransferPoints.get_children()
@onready var blocks = get_tree().get_nodes_in_group("blocks")


# settings
var spawn_on_start = false
var spawn_interval = 3.0 # seconds
var spawn_active = true # press escape to toggle skeletons spawning for debug purposes

var skeleton_count: int = 0
var skeleton_group: Array[CharacterBody2D] = []

var slime_count: int = 0
var slime_group: Array[CharacterBody2D] = []

var sandbag_count: int = 0
var sandbag_group: Array[CharacterBody2D] = []

var block_count = 0

# game states
var game_over = false


func _ready():
	check_win_conditions()
	#----------------------------
	# grumpy bumpy start of game
	#----------------------------

	for b in blocks:
		block_count = +1
		#b.modulate = Color(0.188, 0.612, 0.984)
	blocks[randi_range(0, 39)].set_grumpy()

	block_count = blocks.size()
	print(block_count)

	if spawn_on_start:
		spawn_skeleton()
		spawn_slime()

	# optional: start timer automatically if available
	if has_node("SpawnTimer"):
		$SpawnTimer.wait_time = spawn_interval
		$SpawnTimer.start()

# -------------------------
# spawn logic
# -------------------------


func spawn_skeleton():
	if spawn_points.is_empty() or spawn_active == false or skeleton_count >= 3:
		return

	var point = spawn_points.pick_random()
	var skeleton = skeleton_scene.instantiate()

	skeleton.global_position = point.global_position

	add_child(skeleton)
	skeleton_count += 1
	skeleton_group.append(skeleton)

	# turn the sprite if going through the right transfer since default faces right
	if point.name == "SpawnPointRight":
		skeleton.direction = -1
		var sprite = skeleton.get_node("AnimatedSprite2D")
		sprite.flip_h = true


func spawn_slime():
	if spawn_points.is_empty() or spawn_active == false or slime_count >= 3:
		return

	var point = spawn_points.pick_random()
	var slime = slime_scene.instantiate()

	slime.global_position = point.global_position

	add_child(slime)
	slime_count += 1
	slime_group.append(slime)

	# turn the sprite if going through the right transfer since default faces right
	if point.name == "SpawnPointRight":
		slime.direction = -1
		var sprite = slime.get_node("AnimatedSprite2D")
		sprite.flip_h = true

# -------------------------
# input for testing
# -------------------------


func _input(event):
	#-----------------------------------------------------------------------
	#test spawn
	#-----------------------------------------------------------------------
	if event.is_action_pressed("test_spawn"): # press tab
		spawn_skeleton()
		spawn_slime()
	#-----------------------------------------------------------------------
	#spawn toggle
	#-----------------------------------------------------------------------
	if event.is_action_pressed("toggle_spawn"): # press escape
		spawn_active = !spawn_active
	#-----------------------------------------------------------------------
	#Kill all enemies
	#-----------------------------------------------------------------------
	if event.is_action_pressed("kill_all_enemies"): # press backspace
		for skeleton in skeleton_group.duplicate():
			if is_instance_valid(skeleton):
				skeleton.queue_free()
		skeleton_group.clear()
		skeleton_count = 0
		for slime in slime_group.duplicate():
			if is_instance_valid(slime):
				slime.queue_free()
		slime_group.clear()
		slime_count = 0
	#-----------------------------------------------------------------------
	#Sandbag
	#-----------------------------------------------------------------------
	if event.is_action_pressed("sandbag"):
		if sandbag_count > 0:
			for bag in sandbag_group.duplicate():
				if is_instance_valid(bag):
					bag.queue_free()
					sandbag_group.clear()
					sandbag_count = 0
		print("sandbag")
		var sandbag = sandbag_scene.instantiate()
		var point = spawn_points.pick_random()
		sandbag.global_position = point.global_position
		add_child(sandbag)
		sandbag_count += 1
		sandbag_group.append(sandbag)
# -------------------------
# timer
# -------------------------


func _on_SpawnTimer_timeout():
	spawn_skeleton()
	spawn_slime()


func check_win_conditions():
	var one_player_alive = false
	var players: Array[Node] = get_tree().get_nodes_in_group("players")
	var player_count = players.size()

	for p in players:
		if p.is_dead:
			player_count -= 1
		if player_count == 1:
			one_player_alive = true

	if one_player_alive:
		game_over = true

	print("Game Over!")
