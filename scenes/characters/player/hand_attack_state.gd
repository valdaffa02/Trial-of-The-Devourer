extends State

@export var player: CharacterBody2D
@export var hand_animation_tree : AnimationTree
@onready var hand: Node2D = $"../.."

var is_released_finished = false


func Enter():
	is_released_finished = false
	hand.active_weapon.is_active = true


func Update(delta: float):
	#print(moveDirection)
	hand.rotation_degrees = round(mirror_degrees(rad_to_deg(player.look_direction.angle())))
	hand.adjust_weapon()
	#print(player.hand.rotation_degrees)
	if !is_released_finished:
		if Input.is_action_just_released("mouse_LMBClick"):
			#print("released")
			set_attack_release(true)
			hand.active_weapon.hitbox_component.hitbox.disabled = false
		elif Input.is_action_just_released("mouse_RMBClick"):
			set_idle(true)
	else:
		set_idle(true)


func Physics_Update(delta: float): 
	pass


func set_attack_release(value):
	print("released")
	hand_animation_tree["parameters/conditions/is_attack_pressed"] = !value
	hand_animation_tree["parameters/conditions/is_attack_released"] = value
	hand_animation_tree["parameters/conditions/is_idle"] = !value

func set_idle(value):
	print("idle")
	hand_animation_tree["parameters/conditions/is_attack_pressed"] = !value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = value
	if value:
		Transitioned.emit(self, "HandMeleeIdleState")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "melee_attack_active":
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
