extends State

@export var enemy: CharacterBody2D
@export var hand_animation_tree : AnimationTree

@onready var hand: Node2D = $"../.."
@onready var swing_pause_timer: Timer = $SwingPauseTimer
@onready var body_state_machine: StateMachine = $"../../../StateMachine"

var is_released_finished = false
var is_on_swing_pause = false

func Enter():
	swing_pause_timer.wait_time = randf_range(0.2, 1.0)
	swing_pause_timer.start()
	is_on_swing_pause = true
	is_released_finished = false
	hand.weapon.is_active = true


func Update(delta: float):
	#print(moveDirection)
	hand.rotation_degrees = round(mirror_degrees(rad_to_deg(enemy.look_direction.angle())))
	hand.adjust_weapon()
	#print(player.hand.rotation_degrees)
	if !is_released_finished and enemy.target and (body_state_machine.current_state.name == "ChaseState" or enemy.target_in_line_of_sight):
		if enemy.target_in_range and !is_on_swing_pause:
			#print("released")
			set_attack_release(true)
			hand.weapon.hitbox_component.hitbox.disabled = false
	else:
		enemy.action_cooldown_timer.start()
		enemy.is_on_action_cooldown = true
		set_idle(true)


func Physics_Update(delta: float): 
	pass


func set_attack_release(value):
	#print("enemy released")
	hand_animation_tree["parameters/conditions/is_attack_hold"] = !value
	hand_animation_tree["parameters/conditions/is_attack_released"] = value
	hand_animation_tree["parameters/conditions/is_idle"] = !value

func set_idle(value):
	print("enemy idle")
	hand_animation_tree["parameters/conditions/is_attack_hold"] = !value
	hand_animation_tree["parameters/conditions/is_attack_released"] = !value
	hand_animation_tree["parameters/conditions/is_idle"] = value
	if value:
		Transitioned.emit(self, "HandMeleeIdleState")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "melee_attack_active":
		#print("animation finished!")
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


func _on_swing_pause_timer_timeout() -> void:
	is_on_swing_pause = false
