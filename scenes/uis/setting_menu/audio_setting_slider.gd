extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var audio_number = $HBoxContainer/HBoxContainer/AudioNumber as Label
@onready var h_slider = $HBoxContainer/HBoxContainer/HSlider as HSlider

@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	h_slider.value_changed.connect(on_value_changed)
	get_bus_name_by_index()
	load_data()
	set_name_label_text()
	set_slider_value()


func load_data() -> void:
	match bus_name:
		"Master":
			on_value_changed(SettingsDataContainer.get_master_volume())
		"Music":
			on_value_changed(SettingsDataContainer.get_music_volume())
		"SFX":
			on_value_changed(SettingsDataContainer.get_sfx_volume())

func set_name_label_text() -> void:
	label.text = str(bus_name) + " Volume"


func set_audio_number_label_text() -> void:
	audio_number.text = str(int(h_slider.value * 100)) + "%"


func get_bus_name_by_index() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)


func on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	set_audio_number_label_text()
	
	match bus_index:
		0:
			SettingsSignalBus.emit_on_sound_master_set(value)
		1:
			SettingsSignalBus.emit_on_sound_music_set(value)
		2:
			SettingsSignalBus.emit_on_sound_sfx_set(value)

func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	set_audio_number_label_text()
