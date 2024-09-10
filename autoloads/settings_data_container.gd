extends Node

@onready var DEFAULT_SETTINGS: DefaultSettingsResource = preload("res://scenes/resources/settings/default_setting.tres")
@onready var keybind_resource: PlayerKeybindResources = preload("res://scenes/resources/settings/player_keybind_default.tres")

var window_mode_index: int = 0
var resolution_size_index: int = 0
var master_volume: float = 0.0
var music_volume: float = 0.0
var sfx_volume: float = 0.0

var loaded_data: Dictionary = {}

func _ready():
	handle_signals()
	create_storage_dictionary()


func create_storage_dictionary() -> Dictionary:
	var settings_container_dict: Dictionary = {
		"window_mode_index": window_mode_index,
		"resolution_size_index": resolution_size_index,
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"keybinds": create_keybinds_dictionary()
	}
	
	#print(settings_container_dict)
	return settings_container_dict

func create_keybinds_dictionary() -> Dictionary:
	var keybinds_container_dict: Dictionary = {
		keybind_resource.MOVE_LEFT: keybind_resource.move_left_key,
		keybind_resource.MOVE_RIGHT: keybind_resource.move_right_key,
		keybind_resource.MOVE_UP: keybind_resource.move_up_key,
		keybind_resource.MOVE_DOWN: keybind_resource.move_down_key,
		keybind_resource.SPRINT: keybind_resource.sprint_key
	}
	
	return keybinds_container_dict

# GETTER FUNCTIONS ===========================================================
func get_window_mode_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_WINDOW_MODE_INDEX
	return window_mode_index

func get_resolution_size_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_RESOLUTION_SIZE_INDEX
	return resolution_size_index

func get_master_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_MASTER_VOLUME
	return master_volume

func get_music_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_MUSIC_VOLUME
	return music_volume

func get_sfx_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_SFX_VOLUME
	return sfx_volume

func get_keybind(action: String):
	if !loaded_data.has("keybinds"):
		print("BLUD HAS NO KEYBIND")
		match action:
			keybind_resource.MOVE_LEFT:
				#print(keybind_resource.DEFAULT_MOVE_LEFT_KEY)
				return keybind_resource.DEFAULT_MOVE_LEFT_KEY
			keybind_resource.MOVE_RIGHT:
				return keybind_resource.DEFAULT_MOVE_RIGHT_KEY
			keybind_resource.MOVE_UP:
				return keybind_resource.DEFAULT_MOVE_UP_KEY
			keybind_resource.MOVE_DOWN:
				return keybind_resource.DEFAULT_MOVE_DOWN_KEY
			keybind_resource.SPRINT:
				return keybind_resource.DEFAULT_SPRINT_KEY
	else:
		match action:
			keybind_resource.MOVE_LEFT:
				return keybind_resource.move_left_key
			keybind_resource.MOVE_RIGHT:
				return keybind_resource.move_right_key
			keybind_resource.MOVE_UP:
				return keybind_resource.move_up_key
			keybind_resource.MOVE_DOWN:
				return keybind_resource.move_down_key
			keybind_resource.SPRINT:
				return keybind_resource.sprint_key

# SETTER FUNCTIONS ===========================================================
func on_window_mode_selected(index: int) -> void:
	window_mode_index = index

func on_resolution_size_selected(index: int) -> void:
	resolution_size_index = index

func on_sound_master_set(value: float) -> void:
	master_volume = value

func on_sound_music_set(value: float) -> void:
	music_volume = value

func on_sound_sfx_set(value: float) -> void:
	sfx_volume = value

func set_keybind(action: String, event: InputEventKey) -> void:
	print(action + " " + str(event))
	match action:
		keybind_resource.MOVE_LEFT:
			keybind_resource.move_left_key = event
		keybind_resource.MOVE_RIGHT:
			keybind_resource.move_right_key = event
		keybind_resource.MOVE_UP:
			keybind_resource.move_up_key = event
		keybind_resource.MOVE_DOWN:
			keybind_resource.move_down_key = event
		keybind_resource.SPRINT:
			keybind_resource.sprint_key = event


# LOADER FUNCTIONS ===========================================================
func on_keybinds_loaded(data: Dictionary) -> void:
	var loaded_move_left = InputEventKey.new()
	var loaded_move_right = InputEventKey.new()
	var loaded_move_up = InputEventKey.new()
	var loaded_move_down = InputEventKey.new()
	var loaded_sprint = InputEventKey.new()
	
	loaded_move_left.set_physical_keycode(int(data.move_left))
	loaded_move_right.set_physical_keycode(int(data.move_right))
	loaded_move_up.set_physical_keycode(int(data.move_up))
	loaded_move_down.set_physical_keycode(int(data.move_down))
	loaded_sprint.set_physical_keycode(int(data.sprint))
	
	keybind_resource.move_left_key = loaded_move_left
	keybind_resource.move_right_key = loaded_move_right
	keybind_resource.move_up_key = loaded_move_up
	keybind_resource.move_down_key = loaded_move_down
	keybind_resource.sprint_key = loaded_sprint

func on_settings_data_loaded(data: Dictionary) -> void:
	loaded_data = data
	
	#print(loaded_data)
	on_window_mode_selected(loaded_data.window_mode_index)
	on_resolution_size_selected(loaded_data.resolution_size_index)
	on_sound_master_set(loaded_data.master_volume)
	on_sound_music_set(loaded_data.music_volume)
	on_sound_sfx_set(loaded_data.sfx_volume)
	on_keybinds_loaded(loaded_data.keybinds)


func handle_signals() -> void:
	SettingsSignalBus.on_window_mode_selected.connect(on_window_mode_selected)
	SettingsSignalBus.on_resolution_size_selected.connect(on_resolution_size_selected)
	SettingsSignalBus.on_sound_master_set.connect(on_sound_master_set)
	SettingsSignalBus.on_sound_music_set.connect(on_sound_music_set)
	SettingsSignalBus.on_sound_sfx_set.connect(on_sound_sfx_set)
	SettingsSignalBus.load_settings_data.connect(on_settings_data_loaded)
