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

@onready var enemyMain = get_node("/root/Main/BasicEnemy")
@onready var enemy2 = get_node("/root/Main/BasicEnemy")
@onready var dialogue = load("res://dialogue/key_popup.tscn")

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

func _ready():
	if(get_tree().current_scene.name == "Main"):
		enemyMain.connect("enemy1_hit", Callable(self, "_on_enemy1_hit"))
	elif(get_tree().current_scene.name == "Level2"):
		var enemy1Level2 = get_node("/root/Level2/BasicEnemy")
		var enemy2Level2 = get_node("/root/Level2/BasicEnemy2")
		var enemy3Level2 = get_node("/root/Level2/BasicEnemy3")
		if(enemy1Level2 and enemy2Level2 and enemy3Level2):
			enemy1Level2.connect("enemy1_hit", Callable(self, "_on_enemy1_hit"))
			enemy2Level2.connect("enemy1_hit", Callable(self, "_on_enemy1_hit"))
			enemy3Level2.connect("enemy1_hit", Callable(self, "_on_enemy1_hit"))


func _on_enemy1_hit(damage: int) -> void:
	health -= damage
	$HealthBar.value = health
	$AudioStreamPlayer2D.play()
	print(health)

func _on_key_area_body_entered(body: Node2D) -> void:
	var new_key_obtained = dialogue.instantiate()
	popupText = "Obtained Key!"
	new_key_obtained.text = popupText
	get_tree().current_scene.add_child(new_key_obtained)
	has_key = true


func _on_house_body_entered(body: Node2D) -> void:
	if(body is Player):
		if(has_key):
			get_tree().change_scene_to_file("res://level_2.tscn")
		else:
			var new_key_obtained = dialogue.instantiate()
			popupText = "Door is Locked"
			new_key_obtained.text = popupText
			get_tree().current_scene.add_child(new_key_obtained)

func _on_teddy_bear_body_entered(body: Node2D) -> void:
	if(body is Player):
		var teddy_bear = dialogue.instantiate()
		teddy_bear.text = "Just a Teddy Bear."
		get_tree().current_scene.add_child(teddy_bear)


func _on_potion_body_entered(body: Node2D) -> void:
	if(body is Player):
		var potion = dialogue.instantiate()
		potion.text = "A red potion..."
		get_tree().current_scene.add_child(potion)


func _on_chest_body_entered(body: Node2D) -> void:
	if(body is Player):
		var chest = dialogue.instantiate()
		chest.text = "Where the trees whisper, \n secrets await."
		get_tree().current_scene.add_child(chest)


func _on_portal_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://level_3.tscn")


func _on_back_portal_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://level_2.tscn")
