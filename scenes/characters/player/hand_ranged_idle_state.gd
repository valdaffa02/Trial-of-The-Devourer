class_name HandRangedIdleState
extends State


@export var player: CharacterBody2D
@export var hand_animation_tree : AnimationTree
@onready var hand: Node2D = $"../.."

func Enter():
	hand.rotation_degrees = 0
	hand.active_weapon.is_active = false
	hand.projectile.visible = false


func Update(delta: float):
	hand.adjust_weapon()
	if hand.active_weapon:
		if hand.active_weapon is WeaponMelee:
			set_switch_melee(true)
		
		if Input.is_action_just_pressed("mouse_LMBClick"):
			set_attacking_ranged(true)
		elif Input.is_action_just_pressed("switch_weapon"):
			hand.switch_weapon()


func Physics_Update(delta: float):
	pass


func set_attacking_ranged(value):
	print("pressed")
	hand_animation_tree["parameters/conditions/is_attack_pressed"] = value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = !value
	if value:
		Transitioned.emit(self, "HandRangedAttackState")


func set_switch_melee(value):
	print("switched to melee")
	hand_animation_tree["parameters/conditions/is_melee"] = value
	hand_animation_tree["parameters/conditions/is_ranged"] = !value
	if value:
		Transitioned.emit(self, "HandMeleeIdleState")
