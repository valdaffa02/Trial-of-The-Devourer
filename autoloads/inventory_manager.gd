extends Node


var inventory = []
var hotbar_weapon = []
var hotbar_consumable = []

signal inventory_updated

var player_node : Node = null

@onready var inventory_slot_scene = preload("res://scenes/uis/inventory/inventory_slot.tscn")
@onready var inventory_slot_detail_scene = preload("res://scenes/uis/inventory/inventory_slot_detail.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.resize(30)
	hotbar_weapon.resize(2)
	hotbar_consumable.resize(1)


func add_item(item, to_hotbar = false):
	var added_to_hotbar = false
	
	# Add to hotbar
	if to_hotbar:
		added_to_hotbar = add_hotbar_item(item)
		inventory_updated.emit()
	
	# Add to Inventory
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["name"] == item["name"] and inventory[i]["texture"] == item["texture"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print("item added! 1 ", inventory)
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("item added! 2 ", inventory)
			return true
	return false


func remove_item(item_type, item_name):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["name"] == item_name:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false


func remove_hotbar_item(item_type, item_name):
	for i in range(hotbar_consumable.size()):
		if hotbar_consumable[i] != null and hotbar_consumable[i]["type"] == item_type and hotbar_consumable[i]["name"] == item_name:
			if hotbar_consumable[i]["quantity"] <= 0:
				hotbar_consumable[i] = null
			inventory_updated.emit()
			return true
	return false


func adjust_drop_position(position):
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position


func drop_item(item_data, drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	item_instance.scale = Vector2(0.5, 0.5)
	get_tree().current_scene.add_child(item_instance)


func increase_inventory_size():
	inventory_updated.emit()


func set_player_reference(player):
	player_node = player


func add_hotbar_item(item):
	if item is Weapon:
		for i in range(hotbar_weapon.size()):
			if hotbar_weapon[i] == null:
				hotbar_weapon[i] = item
				return true
	elif item is InventoryItem:
		for i in range(hotbar_consumable.size()):
			if hotbar_consumable[i] == null:
				hotbar_consumable[i] = item
				return true
	else:
		return false


func unassign_hotbar_item(item_type, item_name):
	for i in range(hotbar_consumable.size()):
		if hotbar_consumable[i] != null and hotbar_consumable[i]["type"] == item_type and hotbar_consumable[i]["name"] == item_name:
			hotbar_consumable[i] = null
			inventory_updated.emit()
			return true
	return false
