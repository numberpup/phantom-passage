extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SceneTransition/ColorRect.color.a = 255
	$SceneTransition/AnimationPlayer.play("fade_out")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/LevelScreen.tscn")


func _on_size_3_button_pressed() -> void:
	GameManager.board_size = 3


func _on_size_4_button_pressed() -> void:
	GameManager.board_size = 4


func _on_size_5_button_pressed() -> void:
	GameManager.board_size = 5


func _on_3_obs_button_pressed() -> void:
	GameManager.board_obstacle_count = 3


func _on_5_obs_button_pressed() -> void:
	GameManager.board_obstacle_count = 5


func _on_7_obs_button_pressed() -> void:
	GameManager.board_obstacle_count = 7


func _on_10_dmg_button_pressed() -> void:
	GameManager.player_base_damage = 10


func _on_40_dmg_button_pressed() -> void:
	GameManager.player_base_damage = 40


func _on_80_dmg_button_pressed() -> void:
	GameManager.player_base_damage = 80
