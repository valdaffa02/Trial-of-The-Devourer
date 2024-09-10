extends Node

@onready var audio_stream_player_2d = $AudioStreamPlayer2D as AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func handle_shift(shift_pressed: bool) -> void:
	if shift_pressed:
		audio_stream_player_2d.play()
