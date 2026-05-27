extends Control


func _ready() -> void:
	# Ensure the game tree is unpaused when returning to this screen
	get_tree().paused = false


func _on_battle_mode_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/battle_mode_level.tscn")


func _on_lava_mode_card_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/levels/battle_mode_level.tscn")
