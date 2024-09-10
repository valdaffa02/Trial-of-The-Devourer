extends CharacterBody2D


@onready var body = $Body
@onready var head = $Head
@onready var hand = $Hand

@onready var health_bar: ProgressBar = $HealthBar
@onready var action_cooldown_timer: Timer = $ActionCooldownTimer
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var body_state_machine: StateMachine = $StateMachine

@export var has_static_post : bool = false

const RED_SWORD = preload("res://scenes/commons/items/weapons/melee/red_sword.tscn")
const ICE_SWORD = preload("res://scenes/commons/items/weapons/melee/ice_sword.tscn")

@onready var body_state: Label = $DebugControl/BodyState
@onready var line_of_sight: Label = $DebugControl/LineOfSight

# Normal variables
var move_speed := 100
var move_direction := Vector2.ZERO
var look_direction := Vector2.ZERO

var static_post_position = null

var target = null
var target_in_line_of_sight = false
var target_in_range = false

# Condition booleans
var is_invincible : bool = false
var is_on_action_cooldown : bool = false # For action cooldown like skills and dodge

func _ready() -> void:
	hand.equip_weapon(RED_SWORD, self)


func _process(delta: float) -> void:
	if has_static_post and !static_post_position:
		static_post_position = self.global_position
	
	if body_state_machine.current_state:
		body_state.text = "body state: " + body_state_machine.current_state.name
		#body_state.text = "target: " + body_state_machine.current_state.name


func _physics_process(delta: float) -> void:
	velocity = move_direction * (move_speed * self.scale)
	track_target(target)
	target_in_line_of_sight = check_line_of_sight()
	#print(target_in_line_of_sight)
	move_and_slide()


func track_target(target) -> void:
	if target:
		ray_cast.target_position = to_local(target.global_position)
	else:
		ray_cast.target_position = Vector2(0, 0)


func check_line_of_sight() -> bool:
	if ray_cast.get_collider():
		line_of_sight.text = "target: " + ray_cast.get_collider().name
		print(ray_cast.get_collider().name)
		if ray_cast.get_collider().is_in_group("Player"):
			return true
	return false


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = body


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		target = null


func _on_action_cooldown_timer_timeout() -> void:
	is_on_action_cooldown = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == target:
		target_in_range = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body == target:
		target_in_range = false
