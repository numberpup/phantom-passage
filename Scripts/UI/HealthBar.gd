extends Control

@export var max_health: int = 100
@export var current_health: int = 100

@onready var progress_bar = $ProgressBar

func _ready() -> void:
	setup_health_bar()

func setup_health_bar() -> void:
	# Set the initial values of the health bar
	progress_bar.min_value = 0
	progress_bar.max_value = max_health
	progress_bar.value = current_health

func update_health(value: int) -> void:
	# Update the current health and refresh the progress bar
	current_health = clamp(value, 0, max_health)
	progress_bar.value = current_health
