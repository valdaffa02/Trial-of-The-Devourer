class_name WoodenBow
extends WeaponRanged



# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_scene = preload("res://scenes/commons/items/projectiles/arrow.tscn")
	setup_pickup_area()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_for_user()
	check_for_interaction()
