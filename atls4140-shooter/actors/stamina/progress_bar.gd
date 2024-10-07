extends ProgressBar

var dash: bool = false
var dashAmount: float = 0.0
var canRegen: bool = false

signal stamina_empty(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("dash")):
		$Sprint.play()
		dash = true
	if(Input.is_action_just_released("dash")):
		dash = false
	if(dash):
		if(value <= 0):
			stamina_empty.emit(false)
			await get_tree().create_timer(3).timeout
			canRegen = true
		else:
			canRegen = false
			value -= delta
			stamina_empty.emit(true)
	elif(canRegen):
		if(value <= max_value):
			value += delta
		else:
			canRegen = false
	else:
		stamina_empty.emit(false)
