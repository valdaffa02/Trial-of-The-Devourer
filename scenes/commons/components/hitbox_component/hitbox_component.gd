class_name HitBoxComponent
extends Area2D


@export var statComponent : StatComponent

@onready var hitbox = $CollisionShape2D

var parent : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func damage(attack : AttackComponent):
	if statComponent:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hitbox.disabled:
		hitbox.debug_color = Color(255, 255, 255, 0.5)
	else:
		hitbox.debug_color = Color(255, 0, 90, 0.5)
