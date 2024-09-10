extends State

@export var player: CharacterBody2D
@export var body_animation_tree : AnimationTree

func Update(delta: float):
	if player.look_direction.dot(player.move_direction) < 0:
		player.move_speed = 60
		body_animation_tree.set("parameters/Walk/TimeScale/scale", 0.6)
	else:
		player.move_speed = 100
		body_animation_tree.set("parameters/Walk/TimeScale/scale", 1.0)
	
	if player.move_direction == Vector2.ZERO:
		set_idle(true)
	else:
		update_blend_position(player.look_direction)

func Physics_Update(delta: float):
	pass

func set_idle(value):
	body_animation_tree["parameters/conditions/is_walking"] = !value
	body_animation_tree["parameters/conditions/is_idling"] = value
	if value:
		Transitioned.emit(self, "IdleState")


func update_blend_position(direction):
	body_animation_tree["parameters/Walk/BlendSpace1D/blend_position"] = direction.x
