extends CharacterBody2D
class_name Player

@export var projectile_scene: Resource
@export var move_speed: float = 200.0
@export var hp: int = 10

@export var popupText = "text"

var hold: bool = false
var holdAmount: float = 0.0
var sprint: bool = false
var health: int = 10

var has_key: bool = false

@onready var enemy1 = get_node("/root/Main/BasicEnemy")
@onready var enemy2 = get_node("/root/Main/BasicEnemy")
@onready var key_obtained = load("res://dialogue/key_popup.tscn")
@onready var need_key = load("res://dialogue/door_popup.tscn")

func _input(event):
	if (event is InputEventMouseButton):
		# Only shoot on left click pressed down
		if (event.button_index == 1 and event.is_pressed()):
			holdAmount = 0
			hold = true
			var new_projectile = projectile_scene.instantiate()
			get_parent().add_child(new_projectile)
			var projectile_forward = position.direction_to(get_global_mouse_position())
			new_projectile.fire(projectile_forward, 1000.0)
			new_projectile.position = $Weapon/ProjectileRefPoint.global_position
		if(event.is_released()):
			hold = false

func _process(delta):
	if(hold == true):
		holdAmount += delta
		if(holdAmount >= .6):
			await get_tree().create_timer(.3).timeout
			var new_projectile = projectile_scene.instantiate()
			get_parent().add_child(new_projectile)
			var projectile_forward = position.direction_to(get_global_mouse_position())
			new_projectile.fire(projectile_forward, 3000.0)
			new_projectile.position = $Weapon/ProjectileRefPoint.global_position
			hold = false

func _physics_process(delta):
	
	$Weapon.rotation = position.direction_to(get_global_mouse_position()).angle()
	$Weapon/Sprite2D.flip_v = ($Weapon.rotation < -PI/2 or $Weapon.rotation > PI/2)
	
	velocity = Input.get_vector("move_left", \
		"move_right", \
		"move_up", \
		"move_down") * move_speed
	var newSprint = velocity
	if(sprint):
		velocity = newSprint * 2
	else:
		velocity = newSprint
	move_and_slide()
	
	var angle = rad_to_deg(velocity.angle()) + 180
	if(velocity.length() < 10):
		$AnimationPlayer.play("idle")
	else:
		if(angle > 135 and angle < 255):
			$AnimationPlayer.play("move_right")
		elif(angle > 225 and angle < 315):
			$AnimationPlayer.play("move_front")
		elif(angle > 315 or angle < 45):
			$AnimationPlayer.play("move_left")
		elif(angle > 45 and angle < 135):
			$AnimationPlayer.play("move_back")


func _on_progress_bar_stamina_empty(value: Variant) -> void:
	if(!value):
		sprint = false
	
	if(value):
		sprint = true

	


func _on_enemy1_hit(damage: int) -> void:
	health -= damage
	$HealthBar.value = health


func _on_key_area_body_entered(body: Node2D) -> void:
	var new_key_obtained = key_obtained.instantiate()
	popupText = "Obtained Key!"
	new_key_obtained.text = popupText
	get_tree().current_scene.add_child(new_key_obtained)
	has_key = true


func _on_house_body_entered(body: Node2D) -> void:
	if(body is Player):
		if(has_key):
			get_tree().change_scene_to_file("res://level_2.tscn")
		else:
			var new_key_obtained = key_obtained.instantiate()
			popupText = "Door is Locked"
			new_key_obtained.text = popupText
			get_tree().current_scene.add_child(new_key_obtained)
