# Template of Display Setting Options
extends Control


@onready var option_button = $HBoxContainer/Button as OptionButton

const WINDOW_MODE_ARRAY : Array[String] = [
	"Full-Screen",
	"Windowed",
	"Borderless Full-Screen",
	"Borderless Windowed"
]


func _ready():
	option_button.item_selected.connect(on_window_mode_selected)

func on_window_mode_selected(index: int) -> void:
	pass
