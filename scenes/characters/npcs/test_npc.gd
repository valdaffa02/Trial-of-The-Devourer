extends CharacterBody2D

var is_chatting = false
var is_roaming = false

var is_interactible = false
var is_in_range = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if is_interactible and is_in_range:
		Input.set_custom_mouse_cursor(GuiManager.chat_bubble_cursor, 0, Vector2(6, 6))
		if Input.is_action_just_pressed("mouse_RMBClick"):
			run_dialogue("main_heroine")
	else:
		Input.set_custom_mouse_cursor(null)


func run_dialogue(dialogue_string):
	is_chatting = true
	is_roaming = false
	
	Dialogic.start(dialogue_string)


func _on_hurtbox_component_mouse_entered() -> void:
	is_interactible = true
	#if is_inrange:
		#Input.set_custom_mouse_cursor(GuiManager.chat_bubble_cursor, 0, Vector2(6, 6))
		#is_interactible = true


func _on_hurtbox_component_mouse_exited() -> void:
	is_interactible = false
	#if is_inrange:
		#Input.set_custom_mouse_cursor(null)
		#is_interactible = false
