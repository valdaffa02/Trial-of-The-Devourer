extends State

@export var player: CharacterBody2D
@export var hand_animation_tree : AnimationTree
@onready var hand: Node2D = $"../.."
@onready var attack_timer: Timer = $AttackTimer

var is_released_finished = false
var attack_timer_ended = false


func Enter():
	is_released_finished = false
	attack_timer_ended = false
	hand.active_weapon.is_active = true
	hand.active_weapon.position = hand.hand_sprite.position + Vector2(20, -7)
	hand.projectile.visible = true


func Update(delta: float):
	hand.rotation_degrees = mirror_degrees(rad_to_deg(player.look_direction.angle()))
	hand.adjust_weapon()
	if !is_released_finished:
		if Input.is_action_just_released("mouse_LMBClick"):
			#print("released")
			set_attack_release(true)
			hand.active_weapon.shoot()
			hand.projectile.visible = false
			attack_timer.start()
		elif Input.is_action_just_released("mouse_RMBClick"):
			set_idle(true)
	elif is_released_finished and !attack_timer_ended:
		if Input.is_action_just_pressed("mouse_LMBClick"):
			is_released_finished = false
			set_attack_pressed(true)
			hand.projectile.visible = true
			attack_timer.stop()
	else:
		set_idle(true)


func Physics_Update(delta: float): 
	pass


func set_attack_release(value):
	print("released")
	hand_animation_tree["parameters/conditions/is_attack_pressed"] = !value
	hand_animation_tree["parameters/conditions/is_attack_released"] = value
	hand_animation_tree["parameters/conditions/is_idle"] = !value


func set_attack_pressed(value):
	print("pressed")
	hand_animation_tree["parameters/conditions/is_attack_pressed"] = value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = !value


func set_idle(value):
	print("idle")
	hand_animation_tree["parameters/conditions/is_attack_pressed"] = !value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = value
	if value:
		Transitioned.emit(self, "HandRangedIdleState")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ranged_attack_active":
		print("animation finished")
		is_released_finished = true


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


func _on_attack_timer_timeout() -> void:
	attack_timer_ended = true
