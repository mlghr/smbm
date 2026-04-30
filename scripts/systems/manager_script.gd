extends Node2D

@onready var skeleton_scene = preload("res://scenes/actors/enemy/skeleton.tscn")
@onready var slime_scene = preload("res://scenes/actors/enemy/slime.tscn")
@onready var spawn_points = $SpawnPoints.get_children()
@onready var transfer_points = $TransferPoints.get_children()

# settings
var spawn_on_start = false
var spawn_interval = 3.0 # seconds
var spawn_active = true # press escape to toggle skeletons spawning for debug purposes

var skeleton_count: int = 0
var skeleton_group: Array[CharacterBody2D] = []

var slime_count: int = 0
var slime_group: Array[CharacterBody2D] = []


func _ready():
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
	if event.is_action_pressed("test_spawn"): # press tab
		spawn_skeleton()
		spawn_slime()
	if event.is_action_pressed("toggle_spawn"): # press escape
		spawn_active = !spawn_active
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

# -------------------------
# timer
# -------------------------


func _on_SpawnTimer_timeout():
	spawn_skeleton()
	spawn_slime()
