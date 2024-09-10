extends RayCast2D


var user = null
var is_collision_masks_adjusted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	user = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_collision_masks_adjusted:
		adjust_collision_masks()


func adjust_collision_masks():
	if user:
		for i in range(1, 33):
			if user.get_collision_mask_value(i) and !user.get_collision_layer_value(i):
				self.set_collision_mask_value(i, true)
			else:
				self.set_collision_mask_value(i, false)
	print("collision adjusted")
	is_collision_masks_adjusted = true
