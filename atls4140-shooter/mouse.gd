extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("idle")


func _on_mouse_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
