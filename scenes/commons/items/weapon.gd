class_name Weapon
extends Item


var is_active : bool = false
var is_on_ground : bool = false

var user : CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func check_for_user():
	if user:
		pickup_collision_shape.disabled = true
	else:
		pickup_collision_shape.disabled = false
