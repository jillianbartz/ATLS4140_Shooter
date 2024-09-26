extends State

@export var chase_speed: float = 50.0
var target: CharacterBody2D

func process_state(delta: float):
	var animation_player= get_parent().get_parent().get_node("AnimationPlayer")
	var animation_sprite = get_parent().get_parent().get_node("MainSprite")
	body.velocity = (target.position - body.position).normalized() * chase_speed
	var angle = rad_to_deg(body.velocity.angle())
	if(body.velocity.length() < 0):
		animation_player.play("idle")
	else:
		if (angle < 90 and angle < 270):
				animation_sprite.flip_h = false
		elif (angle >= 90 and angle <= 270):
				animation_sprite.flip_h = true
	body.move_and_slide()
	
