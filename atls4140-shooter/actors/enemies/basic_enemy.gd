extends CharacterStateMachine
class_name Enemy

@export var hp: int = 5

var player_touch = false

signal enemy1_hit(damage: int)

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


func _on_area_2d_area_entered(area: Area2D) -> void:
	enemy1_hit.emit(1)
	player_touch = true
	$AnimationPlayer.stop()
	while player_touch: 
		$AnimationPlayer.play("attack")
		await $AnimationPlayer.animation_finished
		enemy1_hit.emit(1)
		await get_tree().create_timer(1).timeout
	

func _on_area_2d_area_exited(area: Area2D) -> void:
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("idle")
	player_touch = false
