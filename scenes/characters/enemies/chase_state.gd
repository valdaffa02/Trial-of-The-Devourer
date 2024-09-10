extends State

@export var enemy: CharacterBody2D
@export var body_animation_tree : AnimationTree

var last_target_position = null


func Enter():
	enemy.move_speed = 80
	
	if enemy.target and !enemy.target_in_line_of_sight:
		last_target_position = enemy.target.global_position


func Update(delta: float):
	if enemy.navigation_agent:
		if !enemy.target:
			if enemy.global_position.distance_to(last_target_position) > 8:
				enemy.look_direction = enemy.global_position.direction_to(last_target_position)
				if enemy.navigation_agent.target_position != last_target_position:
					enemy.navigation_agent.target_position = last_target_position
				else:
					enemy.move_direction = enemy.global_position.direction_to(enemy.navigation_agent.get_next_path_position())
				update_blend_position(enemy.move_direction)
			else:
				set_idle(true)
		else:
			if !enemy.target_in_range and enemy.target_in_line_of_sight:
				last_target_position = enemy.target.global_position
				#enemy.look_direction = enemy.global_position.direction_to(enemy.navigation_agent.get_next_path_position())
				enemy.look_direction = enemy.global_position.direction_to(enemy.target.global_position)
				enemy.move_direction = enemy.global_position.direction_to(enemy.navigation_agent.get_next_path_position())
				update_blend_position(enemy.move_direction)
			elif enemy.target_in_range and enemy.target_in_line_of_sight:
				set_idle(true)
			else:
				if enemy.global_position.distance_to(last_target_position) > 8:
					enemy.look_direction = enemy.global_position.direction_to(last_target_position)
					if enemy.navigation_agent.target_position != last_target_position:
						enemy.navigation_agent.target_position = last_target_position
					else:
						enemy.move_direction = enemy.global_position.direction_to(enemy.navigation_agent.get_next_path_position())
					update_blend_position(enemy.move_direction)
				else:
					set_idle(true)
			
	else:
		set_idle(true)

func Physics_Update(delta: float):
	pass

func set_idle(value):
	print("enemy_idle")
	body_animation_tree["parameters/conditions/is_wandering"] = !value
	body_animation_tree["parameters/conditions/is_idling"] = value
	body_animation_tree["parameters/conditions/is_chasing"] = !value
	body_animation_tree["parameters/conditions/is_retreating"] = !value
	if value:
		Transitioned.emit(self, "IdleState")


func update_blend_position(direction : Vector2):
	body_animation_tree["parameters/Chase/blend_position"] = direction.x


func _on_navigation_timer_timeout() -> void:
	if enemy.navigation_agent and enemy.target and enemy.target_in_line_of_sight:
		enemy.navigation_agent.target_position = enemy.target.global_position
