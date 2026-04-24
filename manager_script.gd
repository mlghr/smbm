extends Node2D

@onready var skeleton_scene = preload("res://skeleton.tscn")
@onready var spawn_points = $SpawnPoints.get_children()

# settings
var spawn_on_start = true
var spawn_interval = 3.0 # seconds 

func _ready():
	if spawn_on_start:
		spawn_skeleton()

	# optional: start timer automatically if available
	if has_node("SpawnTimer"):
		$SpawnTimer.wait_time = spawn_interval
		$SpawnTimer.start()
		print("timer fired")

# -------------------------
# spawn logic
# -------------------------

func spawn_skeleton():
	if spawn_points.is_empty():
		print("no spawn points found")
		return

	var point = spawn_points.pick_random()
	var skeleton = skeleton_scene.instantiate()
	
	skeleton.global_position = point.global_position
	
	add_child(skeleton)

# -------------------------
# input for testing
# -------------------------

func _input(event):
	if event.is_action_pressed("test_spawn"):  # press tab
		spawn_skeleton()

# -------------------------
# timer
# -------------------------

func _on_SpawnTimer_timeout():
	print("skeleton spawned")
	spawn_skeleton()
