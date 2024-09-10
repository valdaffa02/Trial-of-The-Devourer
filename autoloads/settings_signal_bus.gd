extends Node


signal on_window_mode_selected(index: int)

signal on_resolution_size_selected(index: int)

signal on_sound_master_set(value: float)

signal on_sound_music_set(value: float)

signal on_sound_sfx_set(value: float)

signal set_settings_dictionary(settings_dict: Dictionary)

signal load_settings_data(settings_dict: Dictionary)


func emit_load_settings_data(settings_dict: Dictionary) -> void:
	load_settings_data.emit(settings_dict)

func emit_on_window_mode_selected(index: int) -> void:
	on_window_mode_selected.emit(index)

func emit_on_resolution_size_selected(index: int) -> void:
	on_resolution_size_selected.emit(index)

func emit_on_sound_master_set(value: float) -> void:
	on_sound_master_set.emit(value)

func emit_on_sound_music_set(value: float) -> void:
	on_sound_music_set.emit(value)

func emit_on_sound_sfx_set(value: float) -> void:
	on_sound_sfx_set.emit(value)

func emit_set_settings_dictionary(setting_dict: Dictionary) -> void:
	set_settings_dictionary.emit(setting_dict)
