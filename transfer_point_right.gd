extends Area2D

@onready var right_spawn: Node2D = $"../../SpawnPoints/SpawnPointRight"

func _ready() -> void:
	pass

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.teleport_to(right_spawn)
