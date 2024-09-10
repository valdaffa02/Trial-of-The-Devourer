extends Control

@onready var h_box_weapon_container: HBoxContainer = $MarginContainer/HBoxContainer/HBoxWeaponContainer
@onready var h_box_consumable_container: HBoxContainer = $MarginContainer/HBoxContainer/HBoxConsumableContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManagerS.inventory_updated.connect(update_hotbar_ui)
	update_hotbar_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_hotbar_ui():
	clear_hotbar_container()
	for i in range(InventoryManagerS.equipped_weapon.size()):
			var slot = InventoryManagerS.inventory_slot_scene.instantiate()
			slot.set_hotbar_index(i)
			h_box_weapon_container.add_child(slot)
			if InventoryManagerS.equipped_weapon[i] != null:
				slot.set_item(InventoryManagerS.equipped_weapon[i])
			else:
				slot.set_empty()
	
	for i in range(InventoryManagerS.hotbar_consumable.size()):
			var slot = InventoryManagerS.inventory_slot_scene.instantiate()
			slot.set_hotbar_index(i)
			h_box_consumable_container.add_child(slot)
			if InventoryManagerS.hotbar_consumable[i] != null:
				slot.set_item(InventoryManagerS.hotbar_consumable[i])
			else:
				slot.set_empty()
			
			if slot.slot_detail:
				slot.slot_detail.update_assignment_status()

func clear_hotbar_container():
	while h_box_weapon_container.get_child_count() > 0:
		var child = h_box_weapon_container.get_child(0)
		h_box_weapon_container.remove_child(child)
		child.queue_free()
	
	while h_box_consumable_container.get_child_count() > 0:
		var child = h_box_consumable_container.get_child(0)
		h_box_consumable_container.remove_child(child)
		child.queue_free()
