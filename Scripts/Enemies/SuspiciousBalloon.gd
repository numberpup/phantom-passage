extends "res://Scripts/Enemies/NiceTorso.gd"  # Extend the NiceTorso class

func _ready() -> void:
	# Disable the circle from BaseEnemy
	enable_circle = false

	# Set up the animation specific to SuspiciousBalloon
	setup_animation()

	# Set up the health bar
	setup_health_bar()

	# Scale for better visibility
	scale = Vector2(4, 4)
	animated_sprite.scale = Vector2(4, 4)

func setup_animation() -> void:
	# Create a new SpriteFrames resource
	var sprite_frames = SpriteFrames.new()

	# Load the sprite sheet
	var spritesheet = load("res://Assets/EnemySprites/SuspiciousBalloon.png")

	# Ensure the spritesheet is loaded correctly
	if not spritesheet:
		print("Error: Unable to load spritesheet!")
		return

	# Define frame size and layout
	var frame_width = 32
	var frame_height = 32
	var columns = 4
	var rows = 4
	var total_frames = 14

	# Add animation frames
	sprite_frames.add_animation("default")
	var frame_count = 0
	for y in range(rows):
		for x in range(columns):
			if frame_count >= total_frames:  # Stop after 14 frames
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
	animated_sprite.speed_scale = 2
	
func setup_health_bar() -> void:
	if health_bar == null:
		# Load and instance the HealthBar scene if it's not already initialized
		var health_bar_scene = preload("res://Scenes/UI/HealthBar.tscn")
		health_bar = health_bar_scene.instantiate()
		add_child(health_bar)

	# Adjust the health bar position for SuspiciousBalloon
	var sprite_width = 32 * animated_sprite.scale.x
	var sprite_height = 32 * animated_sprite.scale.y

	# Place the health bar above the sprite
	var bar_width = sprite_width * 1.2
	health_bar.set_size(Vector2(bar_width, 6))
	health_bar.position = Vector2(-bar_width / 2, -sprite_height - 100)

	# Initialize health bar values
	health_bar.max_health = max_health
	health_bar.current_health = health
	health_bar.setup_health_bar()
