extends Node2D

@onready var primary_weapon = null
@onready var secondary_weapon = null
@onready var hand_sprite: Sprite2D = $HandSprite

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_component: AttackComponent = $AttackComponent

var active_weapon = primary_weapon
var projectile : Projectile = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_sprite.z_index = 1
	#hand_anim_tree["parameters/conditions/is_idling"] = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !active_weapon:
		active_weapon = primary_weapon
		secondary_weapon.visible = false


func equip_weapon_primary(weapon: PackedScene, user: Node2D) -> void:
	if primary_weapon:
		primary_weapon.queue_free()
	
	primary_weapon = weapon.instantiate()
	
	add_child(primary_weapon)
	
	primary_weapon.position = hand_sprite.position
	primary_weapon.user = user
	
	if primary_weapon is WeaponRanged:
		equip_projectile(primary_weapon)


func equip_weapon_secondary(weapon: PackedScene, user: Node2D) -> void:
	if secondary_weapon:
		secondary_weapon.queue_free()
	
	secondary_weapon = weapon.instantiate()
	
	add_child(secondary_weapon)
	
	secondary_weapon.position = hand_sprite.position
	secondary_weapon.user = user
	
	if secondary_weapon is WeaponRanged:
		equip_projectile(secondary_weapon)


func equip_projectile(ranged_weapon: WeaponRanged) -> void:
	if projectile:
		projectile.queue_free()
	
	projectile = ranged_weapon.projectile_scene.instantiate()
	
	add_child(projectile)
	
	projectile.position = hand_sprite.position
	projectile.is_in_hand = true
	projectile.hitbox_disabled(true)
	projectile.collision_disabled(true)


func adjust_weapon() -> void:
	if active_weapon:
		if active_weapon is WeaponMelee:
			active_weapon.rotation_degrees = hand_sprite.rotation_degrees
			active_weapon.position = hand_sprite.position
		elif active_weapon is WeaponRanged:
			if active_weapon.is_active and projectile:
				active_weapon.rotation_degrees = hand_sprite.rotation_degrees - 90
				projectile.position = hand_sprite.position
			else:
				active_weapon.rotation_degrees = hand_sprite.rotation_degrees
				active_weapon.position = hand_sprite.position


func switch_weapon() -> void:
	if active_weapon:
		if active_weapon == primary_weapon:
			active_weapon = secondary_weapon
			secondary_weapon.visible = true
			primary_weapon.visible = false
		elif active_weapon == secondary_weapon:
			active_weapon = primary_weapon
			primary_weapon.visible = true
			secondary_weapon.visible = false
		
		if active_weapon is WeaponRanged:
			equip_projectile(active_weapon)
