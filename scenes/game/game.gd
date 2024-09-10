extends Node2D


@export var main_menu = load("res://scenes/uis/main_menu/main_menu.tscn")
@onready var ingame_menu = $CanvasLayer/IngameMenu
@onready var inventory = $CanvasLayer/Inventory
@onready var player: CharacterBody2D = $Player


var frame: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	#inventory.attach_player_sprite(player)
	inventory.set_process(false)
	ingame_menu.set_process(false)
	Global.set_game_reference(self)
	handle_connecting_signals()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		if !ingame_menu.visible:
			#print("escape pressed!")
			open_ingame_menu()
	elif Input.is_action_just_pressed("inventory"):
		if !inventory.visible:
			open_inventory()
	#print("game process going " + str(frame))
	frame += 1
	
	if !is_instance_valid(player):
		print("Game Over")
		set_process(false)


func open_ingame_menu() -> void:
	ingame_menu.visible = true
	ingame_menu.just_entered = true
	set_process(false)
	get_tree().paused = true
	ingame_menu.set_process(true)


func open_inventory() -> void:
	inventory.visible = true
	inventory.just_entered = true
	#set_process(false)
	inventory.set_process(true)


func _on_exit_inventory() -> void:
	inventory.visible = false
	#set_process(true)

func _on_exit_ingame_menu() -> void:
	#print("close ingame menu")
	ingame_menu.visible = false
	set_process(true)
	get_tree().paused = false


func open_main_menu() -> void:
	# set_process(false)
	get_tree().change_scene_to_packed(main_menu)


func handle_connecting_signals():
	ingame_menu.ingame_menu_exited.connect(_on_exit_ingame_menu)
	ingame_menu.game_exited.connect(open_main_menu)
	inventory.inventory_exited.connect(_on_exit_inventory)
