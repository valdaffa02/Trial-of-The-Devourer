extends State

@export var enemy: CharacterBody2D
@export var body_animation_tree : AnimationTree

@export var trans_cooldown_timer: Timer = null

var trans_cooldown_ended = false


func Enter():
	if enemy.navigation_agent.target_position != enemy.static_post_position:
		enemy.navigation_agent.target_position = enemy.static_post_position


func Update(delta: float):
	#print(moveDirection)
	if enemy.target and enemy.target_in_line_of_sight:
		
		if !enemy.target_in_range and trans_cooldown_ended:
			print("enemy position: ", enemy.global_position)
			set_chase(true)
	else:
		#print("retreat line of sight false")
		if enemy.global_position.distance_to(enemy.static_post_position) > 8:
			print("static post: ", enemy.static_post_position)
			print("nav target: ", enemy.navigation_agent.target_position)
			enemy.move_direction = enemy.global_position.direction_to(enemy.navigation_agent.get_next_path_position())
			enemy.look_direction = enemy.move_direction
		else:
			set_idle(true)
	
	update_blend_position(enemy.look_direction)


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

func set_chase(value):
	print("enemy_chase")
	body_animation_tree["parameters/conditions/is_wandering"] = !value
	body_animation_tree["parameters/conditions/is_idling"] = !value
	body_animation_tree["parameters/conditions/is_chasing"] = value
	body_animation_tree["parameters/conditions/is_retreating"] = !value
	if value:
		Transitioned.emit(self, "ChaseState")


func update_blend_position(direction):
	body_animation_tree["parameters/Retreat/blend_position"] = direction.x


func _on_trans_cooldown_timer_timeout() -> void:
	trans_cooldown_ended = true
