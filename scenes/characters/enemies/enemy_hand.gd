extends Node2D

@onready var hand_sprite: Sprite2D = $HandSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_component: AttackComponent = $AttackComponent

var weapon: Weapon = null
var projectile : Projectile = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_sprite.z_index = 1
	#hand_anim_tree["parameters/conditions/is_idling"] = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# for rotations
	# hand_sprite.global_rotation_degrees = rad_to_deg(player.look_direction.angle())
	# print(hand_sprite.global_rotation_degrees)
	adjust_weapon()
	


func equip_weapon(new_weapon: PackedScene, user : Node) -> void:
	if weapon:
		weapon.queue_free()
	
	weapon = new_weapon.instantiate()
	
	add_child(weapon)
	
	weapon.position = hand_sprite.position
	weapon.user = user
	
	if weapon is WeaponRanged:
		equip_projectile(weapon)


func adjust_weapon() -> void:
	if weapon:
		if weapon is WeaponMelee:
			weapon.rotation_degrees = hand_sprite.rotation_degrees
			weapon.position = hand_sprite.position
		elif weapon is WeaponRanged:
			if weapon.is_active and projectile and is_instance_valid(projectile):
				weapon.rotation_degrees = hand_sprite.rotation_degrees - 90
				projectile.position = hand_sprite.position
				weapon.position = Vector2(12, 0)
			else:
				weapon.rotation_degrees = hand_sprite.rotation_degrees
				weapon.position = hand_sprite.position


func equip_projectile(ranged_weapon: WeaponRanged) -> void:
	if !projectile:
		projectile = ranged_weapon.projectile_scene.instantiate()
		
		add_child(projectile)
		
		projectile.position = hand_sprite.position
		projectile.is_in_hand = true
		projectile.hitbox_disabled(true)
		projectile.collision_disabled(true)
