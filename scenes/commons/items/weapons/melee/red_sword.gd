class_name RedSword
extends WeaponMelee



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_name = "Red Sword"
	setup_pickup_area()
	hitbox_disabled(true)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_for_user()
	check_for_interaction()
	if !is_collision_layers_adjusted:
		adjust_collision_layers()
	if !is_collision_masks_adjusted:
		adjust_collision_masks()
