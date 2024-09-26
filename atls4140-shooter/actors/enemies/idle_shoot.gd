extends State

var detect_range: Area2D
var shooting_state: State
var idle_state: State
var animation_player: AnimationPlayer

func initialize():
	detect_range = body.get_node("DetectionRange")
	shooting_state = get_parent().get_node("Shooting")
	idle_state = get_parent().get_node("IdleShoot")
	animation_player = get_parent().get_parent().get_node("AnimationPlayer")
	if(!animation_player.is_playing()):
		animation_player.play("idle")
	

func process_state(delta: float):
	var potential_targets = detect_range.get_overlapping_bodies()
	if (not potential_targets.is_empty()):
		shooting_state.target = (potential_targets[0] as CharacterBody2D)
		change_state.emit(shooting_state)
	else:
		print("?")
		change_state.emit(idle_state)
