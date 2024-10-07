extends Area2D

@onready var dialogue = load("res://dialogue/mouse_dialogue.tscn")
var beginning = null
var label_text = ""
var button1 = null
var button2 = null
var button3 = null
var button_text = ""

var i = 0

var start_chats = [
	"“Oh, hello there, brave adventurer! \n You startled me! 
	I wasn’t expecting company down here in these dark, twisty halls.”",
	"“But tell me, what brings you to this shadowy place?”",
	"“Ah, I see. \n Well, now that you are here, I have some questions for you...”",
	"“While you were bravely adventuring, did you notice a stuffed elephant?”"
]

var incorrect_chats = [
	"Hmmmm.. That doesn't seem to be correct. Try again!"
]

var correct_chats = [
	"Well then your witt is upon you, there was no stuffed elephant in my liar.",
	"What stuffed animal did you see?",
	"Very good. \n I won't go easy on you now- What was the color of the potion?",
	"I'm impressed! Now this one will definitely stump you. \n Where the trees whisper",
	"Eeep! You got them all correct! \n I suppose you are a worthy traveller. \n Your time here is done now. Thank you for finding me."
]

var current_chat = start_chats

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		current_chat = start_chats
		beginning = dialogue.instantiate()
		label_text = beginning.get_node("TextureRect/ColorRect/Label")
		label_text.text = start_chats[i]
		button1 = beginning.get_node("TextureRect/Button1")
		button2 = beginning.get_node("TextureRect/Button2")
		button3 = beginning.get_node("TextureRect/Button3")
		
		button2.visible = false
		button3.visible = false
		
		button1.connect("pressed", Callable(self, "_on_button_pressed").bind(button1))
		button2.connect("pressed", Callable(self, "_on_button_pressed").bind(button2))
		button3.connect("pressed", Callable(self, "_on_button_pressed").bind(button3))
		get_tree().current_scene.add_child(beginning)

func _on_button_pressed(button_pressed: Button):
	i += 1
	if(i == 4 and button_pressed == button1 and current_chat == start_chats):
		current_chat = correct_chats
		i = 0

	if((i == 4 and button_pressed == button2 and current_chat == start_chats)
		or (i == 2 and button_pressed == button2 and current_chat == correct_chats) 
		or (i == 3 and (button_pressed == button1 or button_pressed == button2) and current_chat == correct_chats)
		or (i == 4 and (button_pressed == button2 or button_pressed == button3) and current_chat == correct_chats)):
		current_chat = incorrect_chats
		i = 0
	
	print(i)
	if (i >= current_chat.size()):
		i = 0
		beginning.queue_free()
	else:
		if(i == 0):
			button2.visible = false
			button3.visible = false
			button1.text = "→"
		if(i == 1 and current_chat == start_chats):
			button2.visible = true
			button1.text = "I'm lost"
			button2.text = "I wanted to find you!"
		if(i == 1 and current_chat == correct_chats):
			button2.visible = true
			button1.text = "A teddy bear"
			button2.text = "A snake"
		if(i == 1 and current_chat == incorrect_chats):
			i = 0
			beginning.queue_free()
		if(i == 2):
			button2.visible = false
			button3.visible = false
			button1.text = "Ok!"
		if(i == 3 and current_chat == start_chats):
			button2.visible = true
			button1.text = "No"
			button2.text = "Yes"
		if(i == 2 and current_chat == correct_chats):
			button3.visible = true
			button2.visible = true
			button1.text = "Yellow"
			button2.text = "Green"
			button3.text = "Red"
		if(i == 3 and current_chat == correct_chats):
			button3.visible = true
			button2.visible = true
			button1.text = "... secrets await."
			button2.text = "... shadows stir."
			button3.text = "... mysteries linger."
		if(i == 4):
			button2.visible = false
			button3.visible = false
			button1.text = "→"
		label_text.text = current_chat[i]


func _on_body_exited(body: Node2D) -> void:
	i = 0
	if(beginning != null):
		beginning.queue_free()
