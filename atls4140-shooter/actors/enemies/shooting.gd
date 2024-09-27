extends State

var target: CharacterBody2D
var detect_range: Area2D
var shooting_state: State
var idle_state: State

signal start_shoot(bool)

func process_state(delta: float):
	idle_state = get_parent().get_node("IdleShoot")
	detect_range = body.get_node("DetectionRange")
	var potential_targets = detect_range.get_overlapping_bodies()
	shooting_state = get_parent().get_node("Shooting")
	if (potential_targets.is_empty()):
		start_shoot.emit(false)
		change_state.emit(idle_state)
	else:
		start_shoot.emit(true)
