extends State

@export var chase_speed: float = 50.0
var target: CharacterBody2D

func process_state(delta: float):
	body.velocity = (target.position - body.position).normalized() * chase_speed
	body.move_and_slide()
