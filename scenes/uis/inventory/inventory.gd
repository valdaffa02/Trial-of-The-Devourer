class_name Inventory
extends Control

signal inventory_exited

var just_entered: bool
@onready var inventory_slots: GridContainer = $InventoryMargin/PanelContainer/HBoxContainer/SlotsMarginContainer/VerticalSlotsContainer/ScrollContainer/InventorySlots
@onready var slot_details_node: Control = $InventoryMargin/PanelContainer/HBoxContainer/SlotsMarginContainer/SlotDetailsNode
@onready var inventory_slots_grid: GridContainer = $InventoryMargin/PanelContainer/HBoxContainer/SlotsMarginContainer/VerticalSlotsContainer/ScrollContainer/InventorySlots

@onready var player_inventory_sheet: Control = $InventoryMargin/PanelContainer/HBoxContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/PlayerInventorySheet

var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	InventoryManagerS.inventory_updated.connect(_on_inventory_updated)
	print("on ready: ", player_inventory_sheet.size)
	_on_inventory_updated()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		if !just_entered:
			inventory_exited.emit()
			set_process(false)
	
	if just_entered:
		player_inventory_sheet.rescale_child_container()
		just_entered = false


func _on_inventory_updated():
	# clear existing slots
	clear_grid_container()
	# add slot for each inventory positions
	for item in InventoryManagerS.inventory:
		var slot = InventoryManagerS.inventory_slot_scene.instantiate()
		var slot_detail = InventoryManagerS.inventory_slot_detail_scene.instantiate()
		
		slot.real_position = Vector2((inventory_slots_grid.get_child_count() % 4) * (slot.size.x + 10), floor(inventory_slots_grid.get_child_count()/4) * (slot.size.y + 10) + 30)
		slot.attach_slot_detail(slot_detail)
		
		inventory_slots.add_child(slot)
		slot_details_node.add_child(slot_detail)
		
		#print(str(slot.real_position) + " | " + str(slot_detail.global_position))
		
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
	
	print("occupied slot count: ", inventory_slots.get_child_count())
	print("occupied slot detail count: ", slot_details_node.get_child_count())


func clear_grid_container():
	while inventory_slots.get_child_count() > 0:
		var child = inventory_slots.get_child(0)
		inventory_slots.remove_child(child)
		child.queue_free()
	
	while slot_details_node.get_child_count() > 0:
		var detail_child = slot_details_node.get_child(0)
		slot_details_node.remove_child(detail_child)
		detail_child.queue_free()


func _on_close_button_pressed():
	inventory_exited.emit()
	set_process(false)
	print("Close Button Pressed")
