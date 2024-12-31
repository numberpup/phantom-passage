extends Node2D

# Signals
signal enemy_died

# Enemy properties
@export var health: int = 100
@export var max_health: int = 100
@export var attack_power: int = 10
@export var circle_radius: int = 150  # Bigger circle with 300 pixels diameter
@export var enable_circle: bool = true  # Allow child classes to disable the circle


# Circle color property
var circle_color: Color = Color.RED  # Default value, will be overwritten

# Dictionary to store effects and their values
var effects: Dictionary = {}

func _ready() -> void:
	# Generate a random bright color
	circle_color = generate_random_bright_color()

	# Add health bar
	var health_bar = create_health_bar()
	add_child(health_bar)

	# Call `queue_redraw` to draw the circle
	queue_redraw()

# Draw the circle directly
func _draw() -> void:
	# Draw a filled circle at the center
	if enable_circle:
		draw_circle(Vector2(0, 0), circle_radius, circle_color)

# Generate a random bright color
func generate_random_bright_color() -> Color:
	var hue = randf()  # Random hue between 0 and 1
	var saturation = 0.9  # High saturation for brightness
	var value = 0.9  # High value for brightness
	return Color.from_hsv(hue, saturation, value)

# Create a health bar for the enemy
func create_health_bar() -> ProgressBar:
	var health_bar = ProgressBar.new()

	# Set health bar appearance
	health_bar.value = health
	health_bar.max_value = max_health

	# Resize and position health bar
	health_bar.custom_minimum_size = Vector2(300, 40)  # Make the health bar 300x40 pixels
	health_bar.position = Vector2(-150, -circle_radius - 50)  # Centered above the circle

	return health_bar

# Updates the health bar's value with animation
func update_health_bar():
	for child in get_children():
		if child is ProgressBar:
			var health_bar = child

			# Use create_tween for animations
			var tween = create_tween()
			tween.tween_property(health_bar, "value", health, 0.2)
			return

# Signal handler for `board_clear`
func _on_game_board_board_clear() -> void:
	print("Board clear signal received by BaseEnemy.")
	take_damage(GameManager.player_damage)  # Example damage value

# Called when the enemy takes damage
func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy took damage. Remaining health:", health)
	update_health_bar()
	if health <= 0:
		die()

# Handles enemy death
func die() -> void:
	print("Enemy has been defeated.")
	emit_signal("enemy_died")  # Notify LevelScreen
	queue_free()
