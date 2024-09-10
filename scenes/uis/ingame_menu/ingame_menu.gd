class_name IngameMenu
extends Control


signal ingame_menu_exited
signal game_exited

var just_entered: bool

@onready var ingame_menu_container = $IngameMenuContainer as MarginContainer
@onready var settings_menu = $SettingsMenu as SettingsMenu
@export var game = preload("res://scenes/game/game.tscn")


func _ready():
	pass
	handle_connecting_signals()


func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if !just_entered:
			ingame_menu_exited.emit()
			set_process(false)
	
	just_entered = false


func _on_continue_pressed():
	print("continue pressed!")
	ingame_menu_exited.emit()
	set_process(false)


# Load Game Button Function
func _on_load_pressed():
	print("Load Pressed!")


# Settings Button Function
func _on_settings_pressed():
	print("Setting Pressed!")
	ingame_menu_container.visible = false
	set_process(false)
	settings_menu.visible = true

func _on_main_menu_pressed():
	print("main menu pressed!")
	game_exited.emit()
	set_process(false)

func _on_exit_settings_menu():
	ingame_menu_container.visible = true
	set_process(true)
	settings_menu.visible = false


func on_escape_pressed() -> void:
	ingame_menu_exited.emit()

# Signal Handling Function
func handle_connecting_signals():
	settings_menu.settings_menu_exited.connect(_on_exit_settings_menu)
