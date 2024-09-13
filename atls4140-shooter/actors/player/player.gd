extends CharacterBody2D

@export var projectile_scene: Resource
@export var move_speed: float = 200.0

var hold: bool = false
var holdAmount: float = 0.0
var sprint: bool = false

func _input(event):
	if (event is InputEventMouseButton):
		# Only shoot on left click pressed down
		if (event.button_index == 1 and event.is_pressed()):
			holdAmount = 0
			hold = true
			var new_projectile = projectile_scene.instantiate()
			get_parent().add_child(new_projectile)
			var projectile_forward = Vector2.from_angle(rotation)
			new_projectile.fire(projectile_forward, 1000.0)
			new_projectile.position = $ProjectileRefPoint.global_position
		if(event.is_released()):
			hold = false

func _process(delta):
	if(hold == true):
		holdAmount += delta
		if(holdAmount >= .6):
			await get_tree().create_timer(.3).timeout
			var new_projectile = projectile_scene.instantiate()
			get_parent().add_child(new_projectile)
			var projectile_forward = Vector2.from_angle(rotation)
			new_projectile.fire(projectile_forward, 3000.0)
			new_projectile.position = $ProjectileRefPoint.global_position
			hold = false

func _physics_process(delta):
	look_at(get_viewport().get_mouse_position())
	
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


func _on_progress_bar_stamina_empty(value: Variant) -> void:
	if(!value):
		print("false")
		sprint = false
	
	if(value):
		sprint = true
		print("true")
