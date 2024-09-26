extends CharacterStateMachine
class_name Enemy2

@export var hp: int = 5

@export var projectile_scene: Resource
signal enemy2_hit(damage: int)

@onready var shooting_state = get_node("States/Shooting")

func hit(damage_number: int):
	hp -= damage_number
	print(hp)
	if(hp <= 0):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("dead")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("idle")
		queue_free()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("damage_taken")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")

func _on_shooting_start_shoot(shooting: bool) -> void:
	if($WaitShoot.is_stopped()):
		var new_projectile = projectile_scene.instantiate()
		new_projectile.position = global_position
		get_parent().add_child(new_projectile)
		var projectile_forward = global_position.direction_to(shooting_state.target.global_position)
		new_projectile.fire(projectile_forward, 470.0)
		$WaitShoot.start()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("attack")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("idle")
		return
	
