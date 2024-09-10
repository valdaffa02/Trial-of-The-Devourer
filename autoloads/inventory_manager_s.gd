extends Node


var inventory = []
var equipped_weapon = []
var hotbar_consumable = []

signal inventory_updated

var player_node : Node = null

@onready var inventory_slot_scene = preload("res://scenes/uis/inventory/inventory_slot.tscn")
@onready var inventory_slot_detail_scene = preload("res://scenes/uis/inventory/inventory_slot_detail.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory.resize(30)
	equipped_weapon.resize(2)
	hotbar_consumable.resize(1)


func add_item(item, to_hotbar = false):
	var added_to_hotbar = false
	
	# Add to hotbar
	if to_hotbar:
		added_to_hotbar = add_hotbar_item(item)
		inventory_updated.emit()
	
	# Add to Inventory
	if !added_to_hotbar:
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i]["id"] == item["id"] and inventory[i]["stackable"]:
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


func remove_item(item_id):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["id"] == item_id:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false


func remove_hotbar_item(item_id):
	for i in range(hotbar_consumable.size()):
		if hotbar_consumable[i] != null and hotbar_consumable[i]["id"] == item_id:
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
	item_instance.scale = Vector2(1, 1)
	get_tree().current_scene.add_child(item_instance)


func increase_inventory_size():
	inventory_updated.emit()


func set_player_reference(player):
	player_node = player


func add_hotbar_item(item):
	for i in range(hotbar_consumable.size()):
		if hotbar_consumable[i] == null:
			hotbar_consumable[i] = item
			return true
	return false


func equip_primary(item):
	if equipped_weapon[0] == null:
		equipped_weapon[0] = item
		return true
	else:
		equipped_weapon[0] = item
		return true
	return false


func equip_secondary(item):
	if equipped_weapon[1] == null:
		equipped_weapon[1] = item
		return true
	else:
		equipped_weapon[1] = item
		return true
	return false
	

func unassign_hotbar_item(item_id):
	for i in range(hotbar_consumable.size()):
		if hotbar_consumable[i] != null and hotbar_consumable[i]["id"] == item_id:
			hotbar_consumable[i] = null
			inventory_updated.emit()
			return true
	return false


func is_item_assigned_to_hotbar(item_to_check):
	return item_to_check in hotbar_consumable
