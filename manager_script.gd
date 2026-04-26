extends Node2D

@onready var skeleton_scene = preload("res://skeleton.tscn")
@onready var spawn_points = $SpawnPoints.get_children()
@onready var transfer_points = $TransferPoints.get_children()

# settings
var spawn_on_start = true
var spawn_interval = 3.0 # seconds 
var spawn_active = true # press escape to toggle skeletons spawning for debug purposes

func _ready():
	if spawn_on_start:
		spawn_skeleton()

	# optional: start timer automatically if available
	if has_node("SpawnTimer"):
		$SpawnTimer.wait_time = spawn_interval
		$SpawnTimer.start()

# -------------------------
# spawn logic
# -------------------------

func spawn_skeleton():
	if spawn_points.is_empty() or spawn_active == false:
		return
	
	var point = spawn_points.pick_random()
	var skeleton = skeleton_scene.instantiate()
	
	skeleton.global_position = point.global_position
	
	add_child(skeleton)

	if point.name == "SpawnPointRight":
		skeleton.direction = -1
		var sprite = skeleton.get_node("AnimatedSprite2D")
		sprite.flip_h = true
			
# -------------------------
# input for testing
# -------------------------

func _input(event):
	if event.is_action_pressed("test_spawn"):  # press tab
		spawn_skeleton()
	if event.is_action_pressed("toggle_spawn"): # press escape
		spawn_active = !spawn_active

# -------------------------
# timer
# -------------------------

func _on_SpawnTimer_timeout():
	spawn_skeleton()
