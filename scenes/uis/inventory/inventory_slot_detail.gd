extends Control


@onready var detail_panel: PanelContainer = $DetailPanel
@onready var action_panel: PanelContainer = $ActionPanel

@onready var item_name: Label = $DetailPanel/MarginContainer/VBoxContainer/ItemName
@onready var item_type: Label = $DetailPanel/MarginContainer/VBoxContainer/ItemType
@onready var item_description: RichTextLabel = $DetailPanel/MarginContainer/VBoxContainer/ItemDescription

@onready var use_button: Button = $ActionPanel/MarginContainer/VBoxContainer/UseButton
@onready var drop_button: Button = $ActionPanel/MarginContainer/VBoxContainer/DropButton
@onready var assign_hotbar_button: Button = $ActionPanel/MarginContainer/VBoxContainer/AssignHotbarButton

@onready var equip_primary_button: Button = $ActionPanel/MarginContainer/VBoxContainer/EquipPrimaryButton
@onready var equip_secondary_button: Button = $ActionPanel/MarginContainer/VBoxContainer/EquipSecondaryButton


var item = null

var is_assigned = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detail_panel.visible = false
	action_panel.visible = false
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_drop_button_pressed() -> void:
	if item:
		var drop_position = InventoryManagerS.player_node.position
		var drop_offset = Vector2(0, 50)
		drop_offset = drop_offset.rotated(InventoryManagerS.player_node.look_direction.angle())
		print("Drop item! ", item["name"])
		InventoryManagerS.drop_item(item, drop_position + drop_offset)
		InventoryManagerS.remove_item(item["id"])
		InventoryManagerS.remove_hotbar_item(item["id"])
		action_panel.visible = false





func _on_use_button_pressed() -> void:
	if item:
		pass


func _on_assign_hotbar_button_pressed() -> void:
	if item:
		if is_assigned:
			InventoryManagerS.unassign_hotbar_item(item["id"])
			is_assigned = false
		else:
			InventoryManagerS.add_item(item, true)
			is_assigned = true
		update_assignment_status()


func update_assignment_status():
	is_assigned = InventoryManagerS.is_item_assigned_to_hotbar(item)
	if is_assigned:
		assign_hotbar_button.text = "Unnassign"
	else:
		assign_hotbar_button.text = "Assign"


func _on_equip_primary_button_pressed() -> void:
	pass # Replace with function body.


func _on_equip_secondary_button_pressed() -> void:
	pass # Replace with function body.
