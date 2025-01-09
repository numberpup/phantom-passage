extends Control

@export var score = 0

@onready var score_display = $ScoreDisplay
@onready var enemy_container = $EnemyContainer
@onready var game_board = $MarginContainer/GameBoard  # Corrected path to GameBoard

var encounter_table
var current_enemy
var current_encounter = 0
signal enemy_turn

var is_player_turn = true

func _ready() -> void:
	encounter_table = preload("res://Scripts/DataProcessors/EncounterTable.gd").new()
	progress_encounter()
	$TimerContainer.visible = false
	$SceneTransition/ColorRect.color.a = 255
	$SceneTransition/AnimationPlayer.play("fade_out")
	$InfoBar.update_player_health()
	score_display.text = str(score)
	connect_board_clear_signal()  # Connect the board clear signal
	
	#connect signal from gameboard that enemy turn has triggered damage
	game_board.connect("enemy_attack", Callable(self, "_player_takes_damage"))
	
	instantiate_enemy()

# Connect `board_clear` to all relevant methods
func connect_board_clear_signal() -> void:
	if game_board and not game_board.is_connected("board_clear", Callable(self, "_on_game_board_board_clear")):
		# Connect the signal to update the score display
		game_board.connect("board_clear", Callable(self, "_on_game_board_board_clear"))

# Signal handler for updating the ScoreDisplay
func _on_game_board_board_clear() -> void:
	$DamageDisplay.visible_ratio = 0.0
	$DamageDisplay.text = "[center]" + str(GameManager.player_damage)
	var tween = get_tree().create_tween()
	print($DamageDisplay.text.length())
	tween.tween_property($DamageDisplay, "visible_ratio", 1, .1).set_trans(Tween.TRANS_BACK)
	tween.tween_property($DamageDisplay, "visible_ratio", 0, .8).set_trans(Tween.TRANS_BACK)


# Instantiates the enemy scene as a child of the EnemyContainer and centers it
func instantiate_enemy() -> void:
	var enemy_scene
	
	enemy_scene = preload("res://Scenes/Enemies/EnemyShell.tscn")
	var enemy_instance = enemy_scene.instantiate()
	
	# Connect the updated_enemy_health signal so the infobar can be updated
	enemy_instance.connect("updated_enemy_health", Callable(self, "_on_enemy_health_updated"))
	
	# connect the "enemy_turn" signal to both gameboard
	self.connect("enemy_turn", Callable($MarginContainer/GameBoard, "_on_enemy_turn"))

	enemy_instance._setup(current_enemy, "enemy")
	
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
	

	
	# enemy has been instantiated, now it's the player's turn
	is_player_turn = true

# Signal handler for enemy death
func _on_enemy_died() -> void:
	print("Enemy died. Instantiating a new one...")
	$TimerContainer/Timer.stop()
	$TimerContainer.visible = false
	progress_encounter()
	instantiate_enemy()

func on_timer_change() -> void:
	$TimerContainer/TimerLabel.text = "[center]" + str(ceil($TimerContainer/Timer.time_left))

func _on_player_turn_start() -> void:
	print("player turn start called")
	if $TimerContainer/Timer.is_stopped() == true:
		$TimerContainer.visible = true
		$TimerContainer/Timer.start()

func _on_timer_end() -> void:
	$TimerContainer.visible = false
	emit_signal("enemy_turn")
	

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
	print("Player takes damage inside levelscreen")
	GameManager.player_hp -= GameManager.enemy_attack
	var board_container = $MarginContainer 
	var infoBar = $InfoBar
	infoBar.update_player_health()
	
	if GameManager.player_hp <= 0:
		player_dies()

func player_dies():
	print("player die")
	GameManager.reset()
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")

func progress_encounter() -> void:
	current_encounter = current_encounter + 1
	if current_encounter > 4:
		current_encounter = 1
	current_enemy = encounter_table.floors[1][1][current_encounter]
	print (current_enemy)

# WILL POPULATE ONCE LEVELS AND PROGRESSION ARE IMPLEMENTED
func _level_complete() -> void:
	pass


func _on_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/DebugShopScreen.tscn")

func _process(delta: float) -> void:
	on_timer_change()
