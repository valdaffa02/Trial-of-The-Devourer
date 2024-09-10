extends State

@export var player: CharacterBody2D
@export var body_animation_tree : AnimationTree

func Update(delta: float):
	#print(moveDirection)
	if player.move_direction != Vector2.ZERO:
		set_walking(true)
	else:
		#print(player.lookDirection.x)
		update_blend_position(player.look_direction)


func Physics_Update(delta: float):
	pass

func set_walking(value):
	body_animation_tree["parameters/conditions/is_walking"] = value
	body_animation_tree["parameters/conditions/is_idling"] = !value
	if value:
		Transitioned.emit(self, "WalkState")

func update_blend_position(direction):
	body_animation_tree["parameters/Idle/blend_position"] = direction.x
