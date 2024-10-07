extends ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if(value <= 0):
		#get_tree().paused = true
		#await get_tree().create_timer(.3).timeout
		#get_tree().change_scene_to_file("res://dead.tscn")
