class_name SettingsMenu
extends Control

signal settings_menu_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Back Button Function
func _on_settings_back_pressed():
	print("Back Pressed")
	settings_menu_exited.emit()
	
	# Create Storage Dictionary on Exit
	SettingsSignalBus.emit_set_settings_dictionary(SettingsDataContainer.create_storage_dictionary())
	set_process(false)
