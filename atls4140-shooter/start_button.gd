extends Button

func _on_pressed() -> void:
	print("pressed")
	
	get_tree().change_scene_to_file("res://main.tscn")
