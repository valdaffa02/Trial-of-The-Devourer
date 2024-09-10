extends State

@export var enemy: CharacterBody2D
@export var hand_animation_tree : AnimationTree
@onready var hand: Node2D = $"../.."
@onready var aim_hold_timer: Timer = $AimHoldTimer


var is_released_finished = false
var aim_hold_timer_ended = false


func Enter():
	is_released_finished = false
	aim_hold_timer_ended = false
	if hand.weapon:
		hand.weapon.is_active = true
		#hand.weapon.position = hand.hand_sprite.position + Vector2(20, -7)
	
	if hand.projectile and is_instance_valid(hand.projectile):
		hand.projectile.visible = true
	
	aim_hold_timer.wait_time = randf_range(1, 2)
	aim_hold_timer.start()


func Update(delta: float):
	hand.rotation_degrees = round(mirror_degrees(rad_to_deg(enemy.look_direction.angle())))
	#print(hand.weapon.position, " = ", hand.hand_sprite.position, " + ", Vector2(20, -7) )
	#print(rad_to_deg(enemy.look_direction.angle()))
	hand.adjust_weapon()
	
	if enemy.target and enemy.target_in_range and is_instance_valid(hand.projectile) and enemy.target_in_line_of_sight:
		if !is_released_finished and aim_hold_timer_ended:
			set_attack_release(true)
			hand.weapon.shoot()
			hand.projectile.visible = false
			aim_hold_timer_ended = false
		else:
			set_attack_pressed(true)
			is_released_finished = false
			hand.projectile.visible = true
			aim_hold_timer.wait_time = randf_range(1, 2)
	else:
		set_idle(true)
	'''
	if !is_released_finished and attack_timer_ended:
		if enemy.target:
			if enemy.target_in_range and aim_hold_timer_ended and is_instance_valid(hand.projectile):
				#print("released")
				set_attack_release(true)
				hand.weapon.shoot()
				hand.projectile.visible = false
		else:
			print("to idle 1")
			set_idle(true)
	elif is_released_finished and !attack_timer_ended:
		if enemy.target:
			if enemy.target_in_range and aim_hold_timer_ended and is_instance_valid(hand.projectile):
				is_released_finished = false
				set_attack_pressed(true)
				aim_hold_timer_ended = false
				hand.projectile.visible = true
	else:
		print("to idle 2")
		set_idle(true)
	'''


func Physics_Update(delta: float): 
	pass


func set_attack_release(value):
	#print("released")
	hand_animation_tree["parameters/conditions/is_attack_hold"] = !value
	hand_animation_tree["parameters/conditions/is_attack_released"] = value
	hand_animation_tree["parameters/conditions/is_idle"] = !value


func set_attack_pressed(value):
	#print("pressed")
	hand_animation_tree["parameters/conditions/is_attack_hold"] = value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = !value


func set_idle(value):
	#print("idle")
	hand_animation_tree["parameters/conditions/is_attack_hold"] = !value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = value
	if value:
		Transitioned.emit(self, "HandRangedIdleState")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ranged_attack_active":
		print("active animation finished")
		is_released_finished = true
	elif anim_name == "ranged_attack_hold":
		print("hold animation finished")
		aim_hold_timer.start()


func mirror_degrees(value: float) -> float:
	var max_value = 90
	var min_value = -90
	# If the value exceeds max_value, mirror it back below max_value
	if value > max_value:
		value = -(max_value - (value - max_value))
	
	# If the value goes below min_value, mirror it back above min_value
	elif value < min_value:
		value = -(min_value + (min_value - value))
	
	return value


func _on_aim_hold_timer_timeout() -> void:
	aim_hold_timer_ended = true
