class_name MainMenu
extends Control

var state: String

@onready var main_menu_container = $MainMenuContainer as MarginContainer
@onready var settings_menu = $SettingsMenu as SettingsMenu
@export var game = preload("res://scenes/game/game.tscn")


func _ready():
	set_process(true)
	get_tree().paused = false
	handle_connecting_signals()

func _process(delta):
	pass

# Play Game Button Functio
func _on_play_pressed():
	#get_tree().change_scene_to_file("res://scn/Game.tscn")
	print("Play Pressed!")
	get_tree().change_scene_to_packed(game)


# Load Game Button Function
func _on_load_pressed():
	print("Load Pressed!")


# Settings Button Function
func _on_settings_pressed():
	print("Setting Pressed!")
	main_menu_container.visible = false
	set_process(false)
	settings_menu.visible = true


func _on_exit_settings_menu():
	main_menu_container.visible = true
	set_process(true)
	settings_menu.visible = false


# Quit Button Function
func _on_quit_pressed():
	get_tree().quit()


# Signal Handling Function
func handle_connecting_signals():
	settings_menu.settings_menu_exited.connect(_on_exit_settings_menu)
