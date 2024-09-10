extends Control

# Scene-tree node references
@onready var item_sprite: Sprite2D = $SlotPanel/MarginContainer/ItemSprite
@onready var quantity_panel: PanelContainer = $SlotPanel/MarginContainer/QuantityPanel
@onready var quantity_label: Label = $SlotPanel/MarginContainer/QuantityPanel/MarginContainer/QuantityLabel



var item = null
var slot_detail = null

var real_position : Vector2

var hotbar_index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_hotbar_index(new_index):
	hotbar_index = new_index


func pick_from_slot():
	pass


func _on_item_button_mouse_entered() -> void:
	if item and slot_detail:
		slot_detail.detail_panel.visible = true


func _on_item_button_mouse_exited() -> void:
	if item and slot_detail:
		slot_detail.detail_panel.visible = false


func _on_item_button_pressed() -> void:
	print("clicked!")
	if item and slot_detail:
		slot_detail.action_panel.visible = !slot_detail.action_panel.visible
		slot_detail.detail_panel.visible = false


func set_empty():
	item_sprite.texture = null
	quantity_label.text = ""
	quantity_panel.visible = false


func set_item(new_item):
	item = new_item
	item_sprite.texture = new_item["texture"]
	quantity_label.text = str(new_item["quantity"])
	quantity_panel.visible = true
	
	if slot_detail:
		slot_detail.item = item
		slot_detail.item_name.text = str(new_item["type"])
		slot_detail.item_type.text = str(new_item["name"])
		slot_detail.item_description.text = str(new_item["description"])
		slot_detail.update_assignment_status()


func attach_slot_detail(detail_panel):
	slot_detail = detail_panel
	slot_detail.global_position.x = real_position.x + self.size.x
	slot_detail.global_position.y = real_position.y
