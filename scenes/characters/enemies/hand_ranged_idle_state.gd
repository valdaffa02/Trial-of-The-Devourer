extends State


@export var enemy: CharacterBody2D
@export var hand_animation_tree : AnimationTree
@onready var hand: Node2D = $"../.."

func Enter():
	hand.rotation_degrees = 0
	if hand.weapon:
		hand.weapon.is_active = false
	
	


func Update(delta: float):
	hand.adjust_weapon()
	
	if hand.projectile and is_instance_valid(hand.projectile):
		hand.projectile.visible = false
	
	if enemy.target and enemy.target_in_range and enemy.target_in_line_of_sight:
		set_attacking_ranged(true)


func Physics_Update(delta: float):
	pass


func set_attacking_ranged(value):
	#print("pressed")
	hand_animation_tree["parameters/conditions/is_attack_hold"] = value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = !value
	if value:
		Transitioned.emit(self, "HandRangedAttackState")
