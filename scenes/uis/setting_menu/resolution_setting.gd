extends Control

@onready var option_button = $HBoxContainer/Button as OptionButton

# Dictionary Constant for Resolution
const RESOLUTION_DICTIONARY: Dictionary = {
	"1280 x 720" : Vector2i(1280, 720),
	"1600 x 900" : Vector2i(1600, 900),
	"1920 x 1080" : Vector2i(1920, 1080)
}

func _ready():
	add_resolution_items()
	option_button.item_selected.connect(on_resolution_selected)
	load_data()

# Load data from .sav file through SettingsDataContainer
func load_data() -> void:
	on_resolution_selected(SettingsDataContainer.get_resolution_size_index())
	option_button.select(SettingsDataContainer.get_resolution_size_index())

# function to add items to optionbutton
func add_resolution_items() -> void:
	for resolution_size in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size)

# Function to set resolution
func on_resolution_selected(index: int) -> void:
	SettingsSignalBus.emit_on_resolution_size_selected(index)
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
