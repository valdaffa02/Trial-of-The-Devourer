class_name WeaponRanged
extends Weapon



@export var projectile_scene : PackedScene = null


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_pickup_area()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_for_user()
	check_for_interaction()


func shoot():
	if projectile_scene:
		var projectile_instance = projectile_scene.instantiate() as Projectile
		projectile_instance.direction = user.look_direction
		projectile_instance.spawn_position = user.hand.global_position
		#print(projectile_instance.spawn_position)
		projectile_instance.spawn_rotation = deg_to_rad(mirror_degrees(rad_to_deg(projectile_instance.direction.angle())))
		print(projectile_instance.spawn_rotation)
		projectile_instance.scale = user.scale * user.hand.scale
		#print(projectile_instance.scale, " | ", user.hand.scale)
		projectile_instance.ranged_weapon = self
		if Global.game:
			Global.game.add_child.call_deferred(projectile_instance)


func mirror_degrees(value: float) -> float:
	print("before: ", value)
	var max_value = 90
	var min_value = -90
	# If the value exceeds max_value, mirror it back below max_value
	if value >= max_value:
		value = -(max_value - (value - max_value))
	
	# If the value goes below min_value, mirror it back above min_value
	elif value <= min_value:
		value = -(min_value + (min_value - value))
	
	print("after: ",value)
	return value
