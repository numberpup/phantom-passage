extends Control

@export var score = 0

@onready var score_display = $ScoreDisplay
@onready var enemy_container = $EnemyContainer
@onready var game_board = $MarginContainer/GameBoard  # Corrected path to GameBoard

var is_player_turn = true

func _ready() -> void:
	$SceneTransition/ColorRect.color.a = 255
	$SceneTransition/AnimationPlayer.play("fade_out")

	score_display.text = str(score)
	connect_board_clear_signal()  # Connect the board clear signal
	
	instantiate_enemy()
	
	#$GameBoard.connect("turn_start", Callable(self, "_on_player_turn_start"))
	


# Connect `board_clear` to all relevant methods
func connect_board_clear_signal() -> void:
	if game_board and not game_board.is_connected("board_clear", Callable(self, "_on_game_board_board_clear")):
		# Connect the signal to update the score display
		game_board.connect("board_clear", Callable(self, "_on_game_board_board_clear"))

# Signal handler for updating the ScoreDisplay
func _on_game_board_board_clear() -> void:
	score += 1
	score_display.text = str(score)


# Instantiates the enemy scene as a child of the EnemyContainer and centers it
func instantiate_enemy() -> void:
	var enemy_scene
	
	enemy_scene = preload("res://Scenes/Enemies/EnemyShell.tscn")
	var enemy_instance = enemy_scene.instantiate()
	
	if randi() % (4) == 0:  # Randomly choose an enemy
		enemy_instance._setup("red_guy", "enemy")
	elif randi() % (4) == 1:
		enemy_instance._setup("suspicious_balloon", "enemy")
	elif randi() % (4) == 2:
		enemy_instance._setup("funky_beetle", "enemy")
	else:
		enemy_instance._setup("nice_torso", "enemy")
	
		# Center the enemy manually
	var container_center = enemy_container.size / 2
	enemy_instance.position = container_center
	
	enemy_container.scale = Vector2(0, 0)
	enemy_container.add_child(enemy_instance)
	var tween = get_tree().create_tween()
	tween.tween_property(enemy_container, "scale", Vector2(1,1), .1).set_trans(Tween.TRANS_BACK)
	
	#enemy_instance.modulate = get_random_tint()

	# Connect the GameBoard's `board_clear` signal to the enemy's `_on_game_board_board_clear` method
	if game_board:
		game_board.connect("board_clear", Callable(enemy_instance, "_on_game_board_board_clear"))

	# Connect the enemy_died signal to reinstantiate a new enemy
	enemy_instance.connect("enemy_died", Callable(self, "_on_enemy_died"))
	
	# Connect the updated_enemy_health signal so the infobar can be updated
	enemy_instance.connect("updated_enemy_health", Callable(self, "_on_enemy_health_updated"))
	
	# enemy has been instantiated, now it's the player's turn
	is_player_turn = true

# Signal handler for enemy death
func _on_enemy_died() -> void:
	print("Enemy died. Instantiating a new one...")
	instantiate_enemy()


func _on_player_turn_start() -> void:
	print("player turn start called")
	pass

# Signal handler for enemy health update
func _on_enemy_health_updated() -> void:
	var infoBar = $InfoBar
	infoBar.update_health()

# Generates random tint values for when modulating enemy colors for variety
func get_random_tint(base_color: Color = Color(1, 1, 1)) -> Color:
	# Generate larger random offsets for RGB values
	var red_offset = randf_range(-0.8, 0.8)  # Stronger tint range
	var green_offset = randf_range(-0.8, 0.8)
	var blue_offset = randf_range(-0.8, 0.8)

	# Clamp the final RGB values to stay within valid range (0.0 to 1.0)
	var new_red = clamp(base_color.r + red_offset, 0.0, 1.0)
	var new_green = clamp(base_color.g + green_offset, 0.0, 1.0)
	var new_blue = clamp(base_color.b + blue_offset, 0.0, 1.0)

	return Color(new_red, new_green, new_blue)


func _player_takes_damage() -> void:
	GameManager.player_health -= GameManager.enemy_attack
	var infoBar = $InfoBar
	infoBar.update_player_health()

# WILL POPULATE ONCE LEVELS AND PROGRESSION ARE IMPLEMENTED
func _level_complete() -> void:
	pass


func _on_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/ShopScreen.tscn")
