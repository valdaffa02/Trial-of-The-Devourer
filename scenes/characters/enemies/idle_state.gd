extends State

@export var enemy: CharacterBody2D
@export var body_animation_tree : AnimationTree

@onready var idle_timer: Timer = $IdleTimer
@export var trans_cooldown_timer: Timer = null

var idle_times_up = false
var trans_cooldown_ended = false

func Enter():
	enemy.move_direction = Vector2.ZERO
	idle_times_up = false
	idle_timer.wait_time = randf_range(1.0, 3.0)
	idle_timer.start()
	
	trans_cooldown_ended = false
	trans_cooldown_timer.start()


func Update(delta: float):
	#print(moveDirection)
	if enemy.target and enemy.target_in_line_of_sight:
		print("idle line of sight true")
		if !enemy.target_in_range and trans_cooldown_ended:
			set_chase(true)
		else:
			print("wtf is this?")
			enemy.look_direction = enemy.global_position.direction_to(enemy.target.global_position)
			if enemy.navigation_agent:
				enemy.navigation_agent.target_position = enemy.target.global_position
	else:
		if !enemy.has_static_post:
			if idle_times_up and trans_cooldown_ended:
				set_wander(true)
		# Go back to static post
		else:
			if enemy.global_position.distance_to(enemy.static_post_position) > 8:
				set_retreat(true)
			else:
				enemy.move_direction = Vector2.ZERO
	
	update_blend_position(enemy.look_direction)


func Physics_Update(delta: float):
	pass

func set_wander(value):
	body_animation_tree["parameters/conditions/is_wandering"] = value
	body_animation_tree["parameters/conditions/is_idling"] = !value
	body_animation_tree["parameters/conditions/is_chasing"] = !value
	body_animation_tree["parameters/conditions/is_retreating"] = !value
	if value:
		Transitioned.emit(self, "WanderState")


func set_chase(value):
	print("enemy_chase")
	body_animation_tree["parameters/conditions/is_wandering"] = !value
	body_animation_tree["parameters/conditions/is_idling"] = !value
	body_animation_tree["parameters/conditions/is_chasing"] = value
	body_animation_tree["parameters/conditions/is_retreating"] = !value
	if value:
		Transitioned.emit(self, "ChaseState")


func set_retreat(value):
	print("enemy_retreat")
	body_animation_tree["parameters/conditions/is_wandering"] = !value
	body_animation_tree["parameters/conditions/is_idling"] = !value
	body_animation_tree["parameters/conditions/is_chasing"] = !value
	body_animation_tree["parameters/conditions/is_retreating"] = value
	if value:
		Transitioned.emit(self, "RetreatState")


func update_blend_position(direction):
	body_animation_tree["parameters/Idle/blend_position"] = direction.x


func _on_idle_timer_timeout() -> void:
	idle_times_up = true


func _on_trans_cooldown_timer_timeout() -> void:
	trans_cooldown_ended = true
