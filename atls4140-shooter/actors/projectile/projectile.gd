extends Area2D

var velocity: Vector2 = Vector2(0,0)

func fire(forward: Vector2, speed: float):
	$AudioStreamPlayer2D.play()
	velocity = forward * speed
	look_at(position + forward)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta


func _on_time_to_live_timeout():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	print(body)
	(body).hit(1)
	queue_free()
