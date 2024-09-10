extends Control

@onready var health_progress_bar: ProgressBar = $VBoxContainer/HealthBar/MarginContainer/HealthProgressBar
@onready var stamina_progress_bar: ProgressBar = $VBoxContainer/StaminaBar/MarginContainer/StaminaProgressBar
@onready var magic_progress_bar: ProgressBar = $VBoxContainer/MagicBar/MarginContainer/MagicProgressBar

var player_stat : StatComponent = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_stat = InventoryManagerS.player_node.stat_component


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health_progress_bar.value = (player_stat.health / player_stat.max_health) * 100
	stamina_progress_bar.value = (player_stat.stamina / player_stat.max_stamina) * 100
	magic_progress_bar.value = (player_stat.magic / player_stat.max_magic) * 100
