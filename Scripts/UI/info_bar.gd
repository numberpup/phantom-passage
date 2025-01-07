extends Control

@export var max_health: int = 100
@export var current_health: int = 100

@onready var progress_bar = $HBoxContainer/ProgressBar

func _ready() -> void:
	setup_health_bar()

func setup_health_bar() -> void:
	# Set the initial values of the health bar
	progress_bar.min_value = 0
	progress_bar.max_value = GameManager.enemy_health_max
	progress_bar.value = current_health

func update_health() -> void:
	# Update the progress bar with a bouncy animation
	var tween = get_tree().create_tween()
	tween.tween_property($HBoxContainer/ProgressBar, "value", GameManager.enemy_health, .3).set_trans(Tween.TRANS_BACK)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/ShopScreen.tscn")
