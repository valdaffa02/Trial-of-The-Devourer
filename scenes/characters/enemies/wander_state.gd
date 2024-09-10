extends State

@export var enemy: CharacterBody2D
@export var body_animation_tree : AnimationTree

@onready var wander_timer: Timer = $WanderTimer

var wander_times_up = false

func Enter():
	enemy.move_speed = 30
	wander_times_up = false
	randomize_wander()
	#print(enemy.look_direction)


func Update(delta: float):
	if enemy.target and !enemy.target_in_range and enemy.target_in_line_of_sight:
		set_chase(true)
	
	if wander_times_up or (enemy.target and enemy.target_in_range and enemy.target_in_line_of_sight):
		set_idle(true)
	else:
		update_blend_position(enemy.look_direction)

func Physics_Update(delta: float):
	pass

func set_idle(value):
	body_animation_tree["parameters/conditions/is_wandering"] = !value
	body_animation_tree["parameters/conditions/is_idling"] = value
	body_animation_tree["parameters/conditions/is_chasing"] = !value
	if value:
		Transitioned.emit(self, "IdleState")


func set_chase(value):
	body_animation_tree["parameters/conditions/is_wandering"] = !value
	body_animation_tree["parameters/conditions/is_idling"] = !value
	body_animation_tree["parameters/conditions/is_chasing"] = value
	if value:
		Transitioned.emit(self, "ChaseState")


func update_blend_position(direction : Vector2):
	body_animation_tree["parameters/Wander/blend_position"] = direction.x


func randomize_wander():
	enemy.move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	enemy.look_direction = enemy.move_direction
	
	wander_timer.wait_time = randi_range(1, 3)
	wander_timer.start()


func _on_wander_timer_timeout() -> void:
	wander_times_up = true
