extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = (get_parent().size / 2) - (size / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
