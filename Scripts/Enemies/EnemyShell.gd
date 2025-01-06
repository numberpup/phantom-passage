extends Node2D
var InfoTable
@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
var health_bar
@export var health: int = 100
@export var max_health: int = 100
@export var attack_power: int = 10
@export var enemy_name: String = ""
@export var enemy_key: String =""

#Initialize sprite info variables
@export var sprite: String = ""
@export var sprite_x_dim: int = 32
@export var sprite_y_dim: int = 32
@export var sprite_sheet_cols: int = 3
@export var sprite_sheet_rows: int = 4
@export var sprite_count: int = 10
@export var sprite_offset: int = 0
@export var size_mult = 0
@export var speed_mult = 0

# Signals
signal enemy_died

# INITIALIZATION INSTRUCTIONS:
# TO USE: CALL _setup(enemy_key, enemy_type)
# DO THIS BEFORE CALLING add_child
# THEREFORE THE DATA WILL BE THERE BEFORE _ready IS CALLED

func _setup(enemy: String, enemy_type: String) -> void:
	InfoTable = preload("res://Scripts/DataProcessors/InfoTable.gd").new()
	if enemy_type == "enemy":
		enemy_init(enemy)
	if enemy_type == "mini_boss":
		mini_boss_init(enemy)
	if enemy_type == "boss":
		boss_init(enemy)
	if enemy_type == "king":
		king_init(enemy)
	else:
		print("Unrecognized enemy_type")

func enemy_init(enemy: String) -> void:
	# Enemy stats
	enemy_key = enemy
	enemy_name = InfoTable.enemies[enemy]["name"]
	health = InfoTable.enemies[enemy]["hp"]
	max_health = InfoTable.enemies[enemy]["hp"]
	attack_power = InfoTable.enemies[enemy]["atk"]
	
	# Sprite info
	sprite = InfoTable.enemies[enemy]["sprite"]
	sprite_x_dim = InfoTable.enemies[enemy]["sprite_x_dim"]
	sprite_y_dim = InfoTable.enemies[enemy]["sprite_y_dim"]
	sprite_sheet_cols = InfoTable.enemies[enemy]["sprite_sheet_cols"]
	sprite_sheet_rows = InfoTable.enemies[enemy]["sprite_sheet_rows"]
	sprite_count = InfoTable.enemies[enemy]["sprite_count"]
	sprite_offset = InfoTable.enemies[enemy]["sprite_offset"]
	size_mult = InfoTable.enemies[enemy]["size_mult"]
	speed_mult = InfoTable.enemies[enemy]["speed_mult"]


func mini_boss_init(enemy: String) -> void:
	# load in miniboss
	enemy_key = enemy
	enemy_name = InfoTable.mini_bosses[enemy]["name"]
	health = InfoTable.mini_bosses[enemy]["hp"]
	max_health = InfoTable.mini_bosses[enemy]["hp"]
	attack_power = InfoTable.mini_bosses[enemy]["atk"]
	pass

func boss_init(enemy: String) -> void:
	pass

func king_init(enemy: String) -> void:
	pass

func _ready() -> void:

	# Set up the animation
	setup_animation()
	
	# Set up the health bar
	setup_health_bar()
	
	# Force scale both on the root node and the AnimatedSprite2D
	scale = Vector2(size_mult, size_mult)  # Scale the root node
	animated_sprite.scale = Vector2(size_mult, size_mult)  # Scale the sprite further if needed

func setup_health_bar() -> void:
	# Load and instance the HealthBar scene
	var health_bar = $LevelScreen/InfoBar/ProgressBar

	# Initialize the health bar values
	health_bar.max_health = max_health
	health_bar.current_health = health
	health_bar.setup_health_bar()


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		health = 0
		die()
	update_health_bar()


func setup_animation() -> void:
	# Create a new SpriteFrames resource
	var sprite_frames = SpriteFrames.new()

	# Load the sprite sheet
	var spritesheet = load(sprite)
	print("Setup animation in EnemyShell called")
	
	# Ensure the spritesheet is loaded correctly
	if not spritesheet:
		print("Error: Unable to load spritesheet!")
		return

	# Define frame size and layout
	var frame_width = sprite_x_dim
	var frame_height = sprite_y_dim
	var columns = sprite_sheet_cols
	var rows = sprite_sheet_rows
	var total_frames = sprite_count

	# Add animation frames
	sprite_frames.add_animation("default")
	var frame_count = 0
	for y in range(rows):
		for x in range(columns):
			if frame_count >= total_frames:  # Stop after 10 frames
				break
			var region = Rect2(x * frame_width, y * frame_height, frame_width, frame_height)
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = spritesheet
			atlas_texture.region = region
			sprite_frames.add_frame("default", atlas_texture)
			frame_count += 1

	# Assign the SpriteFrames to the AnimatedSprite2D
	animated_sprite.frames = sprite_frames
	animated_sprite.animation = "default"
	animated_sprite.play("default", true)  # Play the animation on loop
	animated_sprite.speed_scale = speed_mult
	animated_sprite.scale = Vector2(size_mult, size_mult)  # Scale up for visibility

func update_health_bar() -> void:
	if health_bar:
		print("Animating health bar to:", health)

		# Create a tween to smoothly animate the health bar value
		var tween = create_tween()
		tween.tween_property(
			health_bar.progress_bar,  # Tween the ProgressBar node
			"value",  # Animate the `value` property
			health,  # Target value
			0.3  # Duration in seconds
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


# Signal handler for `board_clear`
func _on_game_board_board_clear() -> void:
	print("Board clear signal received by EnemyShell.")
	take_damage(GameManager.player_damage)  # Example damage value


# Handles enemy death
func die() -> void:
	print("Enemy has been defeated.")
	emit_signal("enemy_died")  # Notify LevelScreen
	queue_free()
