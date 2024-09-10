class_name WeaponMelee
extends Weapon


@onready var hitbox_component: HitBoxComponent = $HitboxComponent


var is_collision_layers_adjusted : bool = false
var is_collision_masks_adjusted : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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


func hitbox_disabled(value : bool) -> void:
	hitbox_component.hitbox.disabled = value


func _on_hitbox_component_area_entered(hurtbox) -> void:
	if hurtbox is HurtBoxComponent and hurtbox.get_parent() != user:
		print("this is melee weapons")
		print(str(hurtbox.get_parent().name), user.name)
		hurtbox.damage(self.get_parent().attack_component)


func adjust_collision_layers():
	if user:
		for i in range(1,33):
			if user.get_collision_layer_value(i):
				print(item_name, " layer ", i)
				hitbox_component.set_collision_layer_value(i, true)
			else:
				hitbox_component.set_collision_layer_value(i, false)
	is_collision_layers_adjusted = true


func adjust_collision_masks():
	if user:
		for i in range(1, 33):
			if user.get_collision_mask_value(i) and !user.get_collision_layer_value(i):
				print(item_name, " mask ", i)
				hitbox_component.set_collision_mask_value(i, true)
			else:
				hitbox_component.set_collision_mask_value(i, false)
	is_collision_masks_adjusted = true
