extends Area2D

@onready var left_spawn: Node2D = $"../../SpawnPoints/SpawnPointLeft"


func _ready() -> void:
	pass


func _on_body_entered(body):
	print(" not in if")
	if body.is_in_group("enemy"):
		print("in if")
		body.teleport_to(left_spawn)
