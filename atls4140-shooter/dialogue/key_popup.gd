extends CanvasLayer

var text = "Backup Text"
#var font_size = 10
#var text_size = 32

func _ready() -> void:
	$TextureRect/ColorRect/Label.text = text
	$Duration.start(2.5)
	
func _on_duration_timeout() -> void:
	queue_free()
