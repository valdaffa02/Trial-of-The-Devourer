extends Control

@onready var humanoid_body: Node2D = $Container/HumanoidBody
@onready var humanoid_head: Node2D = $Container/HumanoidHead
@onready var humanoid_hand: Node2D = $Container/HumanoidHand
@onready var container: Container = $Container

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func rescale_child_container() -> void:
	var container_scale = floor(self.size.x / container.size.x)
	container.scale = Vector2(container_scale, container_scale)
	print(container_scale)
