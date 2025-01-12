extends Node2D
var InfoTable
@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
@onready var attack_sprite = $AttackAnimatedSprite2D  # Reference to the attack animation node

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
signal updated_enemy_health
signal enemy_attack

# INITIALIZATION INSTRUCTIONS:
# TO USE: CALL _setup(enemy_key, enemy_type)
# DO THIS BEFORE CALLING add_child
# THEREFORE THE DATA WILL BE THERE BEFORE _ready IS CALLED

var enemy_floor_multipliers = [1, 1, 10, 20, 500, 100]

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
	# grab enemy_floor_multiplier
	var mult = enemy_floor_multipliers[GameManager.current_floor]
	print("MULT: " + str(mult))
	
	# Enemy stats
	enemy_key = enemy
	enemy_name = InfoTable.enemies[enemy]["name"]
	health = InfoTable.enemies[enemy]["hp"]*mult
	max_health = InfoTable.enemies[enemy]["hp"]*mult
	attack_power = InfoTable.enemies[enemy]["atk"]*mult
	
	print("inside enemyshell: hp: " + str(max_health))
	print("inside enemyshell: attack: " + str(attack_power))
	
	# Update global enemy stats
	GameManager.enemy_health_max = InfoTable.enemies[enemy]["hp"]
	GameManager.enemy_health = InfoTable.enemies[enemy]["hp"]
	GameManager.enemy_attack = attack_power
	
	print("inside enemyshell: gamemanager enemy hp: " + str(GameManager.enemy_health_max))
	print("inside enemyshell: gamemanager attack: " + str(GameManager.enemy_attack))
	
	emit_signal("updated_enemy_health")
	print("Inside enemy_init, enemyhealth: " + str(GameManager.enemy_health_max))
	
	
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

func boss_init(enemy: String) -> void:
	pass

func king_init(enemy: String) -> void:
	pass

func _ready() -> void:
	# Set up the animation
	setup_animation()
	
	# Emit signal indicating the global health was updated
	emit_signal("updated_enemy_health")
	
	
	
	# Force scale both on the root node and the AnimatedSprite2D
	scale = Vector2(size_mult, size_mult)  # Scale the root node
	animated_sprite.scale = Vector2(size_mult, size_mult)  # Scale the sprite further if needed


func take_damage(amount: int) -> void:
	health -= amount
	
	# Call attack animation
	attack_animation()
	var old_modulate = self.modulate
	var original_position = self.position
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(69, 12, 12), .05).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "modulate", old_modulate, .05).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", Vector2(self.position.x+50, self.position.y-40), .01).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "position", original_position, .1).set_trans(Tween.TRANS_BOUNCE)

	# Update global enemy_health variable
	GameManager.enemy_health = health
	
	if health <= 0:
		health = 0
		die()
	#else:
		#emit_signal("enemy_attack") # enemy take turn
		
	# CALL AN updated_enemy_health SIGNAL
	if not GameManager.player_hp <= 0:
		emit_signal("updated_enemy_health")

func attack_animation() -> void:
	var sprite_frames = SpriteFrames.new()
	var spritesheet = load("res://Assets/AnimationSprites/AttackAnim.png")
	
	# Define frame size and layout
	var frame_width = 64
	var frame_height = 64
	var columns = 2
	var rows = 3
	var total_frames = 6
	
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
	sprite_frames.set_animation_loop("default", false) #make animation not loop
	attack_sprite.frames = sprite_frames
	#attack_sprite.animation = "default"
	attack_sprite.play("default")  # Play the animation
	attack_sprite.speed_scale = 6
	attack_sprite.scale = Vector2(4, 4)  # Scale up for visibility

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

# Signal handler for `board_clear`
func _on_game_board_board_clear() -> void:
	print("Board clear signal received by EnemyShell.")
	take_damage(GameManager.effective_player_damage)

# Handles enemy death
func die() -> void:
	print("Enemy has been defeated.")
	
	await get_tree().create_timer(.1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(0,0), .2).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(.1).timeout
	emit_signal("enemy_died")  # Notify LevelScreen
	emit_signal("updated_enemy_health")
	await get_tree().create_timer(.2).timeout
	queue_free()
