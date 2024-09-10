class_name Arrow
extends Projectile

var item_name = "Arrow"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 300
	life = 1
	adjust_spawn()


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
