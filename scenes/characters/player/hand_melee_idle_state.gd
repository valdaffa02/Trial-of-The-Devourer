extends State

@export var player: CharacterBody2D
@export var hand_animation_tree : AnimationTree
@onready var hand: Node2D = $"../.."

func Enter():
	hand.rotation_degrees = 0
	if hand.active_weapon:
		hand.active_weapon.hitbox_component.hitbox.disabled = true
		hand.active_weapon.is_active = false


func Update(delta: float):
	hand.adjust_weapon()
	
	if hand.active_weapon:
		if hand.active_weapon is WeaponMelee:
			hand.active_weapon.hitbox_component.hitbox.disabled = true
		elif hand.active_weapon is WeaponRanged:
			set_switch_ranged(true)
		
		if Input.is_action_just_pressed("mouse_LMBClick"):
			set_attacking_melee(true)
		elif Input.is_action_just_pressed("switch_weapon"):
			hand.switch_weapon()


func Physics_Update(delta: float):
	pass


func set_attacking_melee(value):
	print("pressed")
	hand_animation_tree["parameters/conditions/is_attack_pressed"] = value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = !value
	if value:
		Transitioned.emit(self, "HandMeleeAttackState")


func set_switch_ranged(value):
	print("switched to ranged")
	hand_animation_tree["parameters/conditions/is_ranged"] = value
	hand_animation_tree["parameters/conditions/is_melee"] = !value
	if value:
		Transitioned.emit(self, "HandRangedIdleState")
