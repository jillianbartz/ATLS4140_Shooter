extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if($Player2/HealthBar.value <= 0):
		get_tree().paused = true
		get_tree().change_scene_to_file("res://dead.tscn")
