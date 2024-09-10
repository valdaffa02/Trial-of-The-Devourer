extends ProgressBar

@export var stat_component : StatComponent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = (stat_component.health / stat_component.max_health) * 100
	#print(str(value) + " " + str(stat_component.health) + "/" + str(stat_component.max_health) + " * 100")
