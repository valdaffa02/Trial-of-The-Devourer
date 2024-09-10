extends CharacterBody2D

# Child Nodes Variables
# Node variables for UI
@onready var camera = $Camera2D
@onready var interact_ui: ColorRect = $InteractUI

# Node variables for bodyparts
@onready var body: Node2D = $Body
@onready var head: Node2D = $Head
@onready var hand: Node2D = $Hand

# Node variables for components
@onready var stat_component: StatComponent = $StatComponent

# Node variables for timers
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var action_timer: Timer = $ActionTimer
@onready var regen_timer: Timer = $RegenTimer

const ICE_SWORD = preload("res://scenes/commons/items/weapons/melee/ice_sword.tscn")
const WOODEN_BOW = preload("res://scenes/commons/items/weapons/ranged/wooden_bow.tscn")
const ARROW = preload("res://scenes/commons/items/projectiles/arrow.tscn")
const RED_SWORD = preload("res://scenes/commons/items/weapons/melee/red_sword.tscn")


# Normal variables
var move_speed := 100
var move_direction := Vector2.ZERO
var look_direction := Vector2.ZERO


# Condition booleans
var is_invincible : bool = false
var is_on_action_cooldown : bool = false # For action cooldown like skills and dodge
var is_on_regen_cooldown : bool = false # For stat regeneration


func _ready():
	hand.equip_weapon_primary(WOODEN_BOW, self)
	hand.equip_weapon_secondary(ICE_SWORD, self)
	InventoryManagerS.set_player_reference(self)


func _process(delta):
	pass


func _physics_process(delta):
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	look_direction = position.direction_to(get_mouse_relative_position())
	
	if Input.is_action_pressed("sprint") and stat_component.stamina > 0:
		print("sprint")
		stat_component.stamina -= 0.2
		print(stat_component.stamina)
		move_speed = 150
	elif Input.is_action_just_released("sprint"):
		print("walk")
		regen_timer.start()
		is_on_regen_cooldown = true
		move_speed = 100
	else:
		if !is_on_regen_cooldown and stat_component.stamina < stat_component.max_stamina:
			stat_component.stamina += 0.1
		move_speed = 100
	
	velocity = move_direction * (move_speed * self.scale)
	
	move_and_slide()


func dash():
	if !is_on_action_cooldown:
		print("dash")
		action_timer.start()


func get_mouse_relative_position() -> Vector2:
	return get_viewport().get_mouse_position() + (camera.get_target_position() - (get_viewport_rect().size / 2))


func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Npcs"):
		body.is_in_range = true


func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Npcs"):
		body.is_in_range = false


func _on_invincible_timer_timeout() -> void:
	is_invincible = false


func _on_action_timer_timeout() -> void:
	is_on_action_cooldown = false


func _on_regen_timer_timeout() -> void:
	is_on_regen_cooldown = false


func _on_hurtbox_component_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass


func _on_hurtbox_component_body_entered(body: Node2D) -> void:
	pass
