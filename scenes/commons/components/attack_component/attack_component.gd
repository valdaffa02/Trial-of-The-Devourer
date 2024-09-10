class_name AttackComponent
extends Node


@export var attack_damage : float
@export var attack_knockback : float
var attack_position : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	attack_position = get_parent().global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attack_position = get_parent().global_position
