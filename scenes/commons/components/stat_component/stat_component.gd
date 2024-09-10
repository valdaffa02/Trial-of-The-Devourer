class_name StatComponent
extends Node

@export_category("Mortality")
@export var is_immortal : bool = false

@export_category("Primary Statistic")
@export var max_health : int = 0
@export var max_magic : int = 0
@export var max_stamina : int = 0

@export_category("Secondary Statistic")
@export var strength : int = 0
@export var agility : int = 0
@export var endurance: int = 0
@export var charisma : int = 0
@export var cunning : int = 0

# DO NOT MAKE THESE STAT AS AN INTEGER!!!
var health
var magic
var stamina

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	stamina = max_stamina
	magic = max_magic

func damage(attack : AttackComponent):
	if !is_immortal:
		print(attack.attack_damage)
		health -= attack.attack_damage
		print("current health: " + str(health))
		
		if health <= 0:
			get_parent().queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
