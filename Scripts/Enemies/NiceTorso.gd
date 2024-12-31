extends "res://Scripts/Enemies/BaseEnemy.gd"  # Extend the BaseEnemy class

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
var health_bar


func _ready() -> void:
	# Disable the circle from BaseEnemy
	enable_circle = false

	# Set up the animation
	setup_animation()
	
	# Set up the health bar
	setup_health_bar()
	
	# Force scale both on the root node and the AnimatedSprite2D
	scale = Vector2(4, 4)  # Scale the root node
	animated_sprite.scale = Vector2(4, 4)  # Scale the sprite further if needed

func setup_health_bar() -> void:
	# Load and instance the HealthBar scene
	var health_bar_scene = preload("res://Scenes/UI/HealthBar.tscn")
	health_bar = health_bar_scene.instantiate()
	add_child(health_bar)

	# Calculate proportional size based on the sprite's scale
	var sprite_width = 32 * animated_sprite.scale.x  # Assume 32px per frame width
	var sprite_height = 32 * animated_sprite.scale.y  # Assume 32px per frame height

	# Set the size of the HealthBar's root container
	var bar_width = sprite_width * 1.2  # Health bar width is 1.2x the sprite width
	health_bar.set_size(Vector2(bar_width, 10))  # Set size for the container node

	# Center and position the health bar above the sprite
	health_bar.position = Vector2(-bar_width / 2, -sprite_height - 8)  # Centered above the sprite

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
	var spritesheet = load("res://Assets/EnemySprites/NiceTorso.png")
	print("Setup animation in NiceTorso called")
	
	# Ensure the spritesheet is loaded correctly
	if not spritesheet:
		print("Error: Unable to load spritesheet!")
		return

	# Define frame size and layout
	var frame_width = 32
	var frame_height = 32
	var columns = 3
	var rows = 4
	var total_frames = 10

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
	animated_sprite.speed_scale = 4.0  # Play at 12 FPS
	animated_sprite.scale = Vector2(4, 4)  # Scale up for visibility

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
