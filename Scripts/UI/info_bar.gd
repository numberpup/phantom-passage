extends Control

@onready var progress_bar = $HBoxContainer/ProgressBar

@onready var loaded_tree = get_tree()
var animate_height = false

func _ready() -> void:
	setup_health_bar()

func setup_health_bar() -> void:
	# Set the initial values of the health bar
	progress_bar.min_value = 0
	progress_bar.max_value = GameManager.enemy_health_max
	print(progress_bar.max_value)
	progress_bar.value = GameManager.enemy_health

func update_health() -> void:
	# Update the progress bar with a bouncy animation
	var tween = loaded_tree.create_tween()
	progress_bar.max_value = GameManager.enemy_health_max
	tween.tween_property($HBoxContainer/ProgressBar, "value", GameManager.enemy_health, .3).set_trans(Tween.TRANS_BACK)

func setup_player_health_bar() -> void:
	# Set the initial values of the health bar
	progress_bar.min_value = 0
	progress_bar.max_value = GameManager.player_health_max
	progress_bar.value = GameManager.player_health

func update_player_health() -> void:
	# Update the progress bar with a bouncy animation
	var tween = get_tree().create_tween()
	var original_size = $HBoxContainer2/ProgressBar2.size
	
	if animate_height == true:
		tween.tween_property($HBoxContainer2/ProgressBar2, "size", Vector2($HBoxContainer2/ProgressBar2.size.x, $HBoxContainer2/ProgressBar2.size.y + 30), .15).set_trans(Tween.TRANS_BACK)

	tween.tween_property($HBoxContainer2/ProgressBar2, "value", GameManager.player_hp, .3).set_trans(Tween.TRANS_BACK)
	if animate_height == true:
		tween.tween_property($HBoxContainer2/ProgressBar2, "size", original_size, .3).set_trans(Tween.TRANS_BACK)
	
	if animate_height == false:
		animate_height = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/DebugShopScreen.tscn")
