extends Area2D

@onready var left_spawn: Node2D = $"../../SpawnPoints/SpawnPointLeft"

func _ready() -> void:
	pass

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.teleport_to(left_spawn)
