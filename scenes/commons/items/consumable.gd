@tool
class_name Consumable
extends Item


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		item_sprite.texture = item_texture
		setup_pickup_area()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		item_sprite.texture = item_texture
		setup_pickup_area()
	
	check_for_interaction()
