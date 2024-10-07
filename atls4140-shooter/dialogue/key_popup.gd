extends CanvasLayer

var text = "Backup Text"
var font_size = 10
var text_size = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect/ColorRect/Label.text = text
	$Duration.start(1.5)
	
func _on_duration_timeout() -> void:
	queue_free()
