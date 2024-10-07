extends Node2D

func _ready():
	get_tree().paused = false

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
