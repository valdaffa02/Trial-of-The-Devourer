class_name HurtBoxComponent
extends Area2D


@export var stat_component : StatComponent

@onready var hurtbox = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func damage(attack : AttackComponent):
	print("attack detected!")
	if stat_component && !get_parent().is_invincible:
		stat_component.damage(attack)
		# get_parent().is_invincible = true
		if attack.attack_knockback > 0:
			print("Attack KnockBack: " + str(attack.attack_knockback))
			# get_parent().is_knocked = true
			# get_parent().move_direction = (get_parent().global_position - attack.attack_position).normalized()
			# print("Knockback direction: " + str(get_parent().move_direction))
			#get_parent().move_speed = attack.attack_knockback
	else:
		#print("hit!")
		pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
