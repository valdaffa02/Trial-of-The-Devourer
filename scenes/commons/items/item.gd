@tool
extends Node2D
class_name Item

@export var item_id = ""
@export var item_type = ""
@export var item_name = ""
@export var item_texture : Texture
@export var item_description = ""
@export var scene_path = ""
@export var stackable : bool = false

@onready var item_sprite: Sprite2D = $ItemSprite
@onready var pickup_collision_shape: CollisionShape2D = $PickupArea/CollisionShape2D

var player_in_range = false


# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		item_sprite.texture = item_texture
		setup_pickup_area()
		


func _process(delta: float):
	if Engine.is_editor_hint():
		item_sprite.texture = item_texture
		setup_pickup_area()
	
	check_for_interaction()


func pickup_item():
	print(item_id, item_type, item_name)
	var item = {
		"quantity" : 1,
		"id" : item_id,
		"type" : item_type,
		"name" : item_name,
		"texture" : item_texture,
		"description" : item_description,
		"scene_path" : scene_path,
		"stackable" : stackable,
	}
	if InventoryManagerS.player_node:
		InventoryManagerS.add_item(item, false)
		self.queue_free()


func set_item_data(data):
	item_id = data["id"]
	item_type = data["type"]
	item_name = data["name"]
	item_description = data["description"]
	item_texture = data["texture"]
	stackable = data["stackable"]


func setup_pickup_area():
	if !pickup_collision_shape.shape:
		var shape = CircleShape2D.new()
		shape.radius = 20.0
		pickup_collision_shape.shape = shape


func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		print("in range!")
		body.interact_ui.visible = true


func _on_pickup_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		body.interact_ui.visible = false


func check_for_interaction():
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("interacted with ", item_name)
		pickup_item()
