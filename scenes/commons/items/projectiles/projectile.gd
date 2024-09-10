class_name Projectile
extends CharacterBody2D

@onready var hitbox_component : HitBoxComponent = $HitboxComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite: Sprite2D = $Sprite

var ranged_weapon : WeaponRanged = null

var is_collision_layers_adjusted : bool = false
var is_collision_masks_adjusted : bool = false
var is_in_hand : bool = false

var direction = null
var spawn_position = null
var spawn_rotation = null
var spawn_scale = null

@export var item_name : String = ""
@export var speed : int = 100
@export var life : int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	adjust_spawn()
	print("SHOOOT")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_collision_layers_adjusted:
		adjust_collision_layers()
	if !is_collision_masks_adjusted:
		adjust_collision_masks()


func _physics_process(delta: float) -> void:
	if direction:
		velocity = direction * abs(speed * self.scale)
		move_and_slide()
		#print(rad_to_deg(spawn_rotation), " | ", rad_to_deg(global_rotation))


func adjust_spawn()->void:
	if spawn_position:
		global_position = spawn_position
	
	if spawn_rotation:
		global_rotation = spawn_rotation
		print("projectile rotation:", rad_to_deg(global_rotation), " or " , global_rotation, " | ", rad_to_deg(spawn_rotation), " or ", spawn_rotation )


func adjust_collision_layers():
	if ranged_weapon:
		if is_in_hand:
			for i in range(1,33):
				if ranged_weapon.user.get_collision_layer_value(i):
					print(i)
					self.set_collision_layer_value(i, true)
					hitbox_component.set_collision_layer_value(i, true)
				else:
					self.set_collision_layer_value(i, false)
					hitbox_component.set_collision_layer_value(i, false)
		else:
			for i in range(1,33):
				if i == 6:
					#print("projectile's layer ",i)
					self.set_collision_layer_value(i, true)
					hitbox_component.set_collision_layer_value(i, true)
				else:
					self.set_collision_layer_value(i, false)
					hitbox_component.set_collision_layer_value(i, false)
	
	is_collision_layers_adjusted = true


func adjust_collision_masks():
	if ranged_weapon:
		for i in range(1, 33):
			if ranged_weapon.user.get_collision_mask_value(i) and !ranged_weapon.user.get_collision_layer_value(i):
				#print("projectile's mask ",i)
				self.set_collision_mask_value(i, true)
				hitbox_component.set_collision_mask_value(i, true)
			else:
				self.set_collision_mask_value(i, false)
				hitbox_component.set_collision_mask_value(i, false)
	
	is_collision_masks_adjusted = true


func hitbox_disabled(value: bool):
	if hitbox_component.hitbox:
		hitbox_component.hitbox.disabled = value

func collision_disabled(value: bool):
	collision_shape_2d.disabled = value

func _on_hitbox_component_area_entered(hurtbox):
	if hurtbox is HurtBoxComponent:
		#print(hurtbox.get_parent().name, " | Collision layer: ")
		for i in range(1, 33):
			if hurtbox.get_collision_layer_value(i):
				print(i)
		hurtbox.damage(ranged_weapon.get_parent().attack_component)
		
		if life <= 1:
			self.queue_free()
		else:
			life -= 1


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if self.visible and !is_in_hand:
		#print("projectile deleted!")
		self.queue_free()


func _on_hitbox_component_body_entered(body: Node2D) -> void:
	#print(body.name)
	if body is TileMapLayer:
		print("environment hit!")
		self.queue_free()
