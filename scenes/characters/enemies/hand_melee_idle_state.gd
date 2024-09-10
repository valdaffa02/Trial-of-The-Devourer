extends State

@export var enemy: CharacterBody2D
@export var hand_animation_tree : AnimationTree
@onready var hand: Node2D = $"../.."

func Enter():
	hand.rotation_degrees = 0
	if hand.weapon:
		hand.weapon.hitbox_component.hitbox.disabled = true
		hand.weapon.is_active = false


func Update(delta: float):
	hand.adjust_weapon()
	
	if hand.weapon:
		hand.weapon.hitbox_component.hitbox.disabled = true
		if enemy.target and enemy.target_in_line_of_sight and !enemy.is_on_action_cooldown:
			set_attacking_melee(true)


func Physics_Update(delta: float):
	pass


func set_attacking_melee(value):
	hand_animation_tree["parameters/conditions/is_attack_hold"] = value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = !value
	if value:
		Transitioned.emit(self, "HandMeleeAttackState")
