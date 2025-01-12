extends Control

@onready var info_table = preload("res://Scripts/DataProcessors/InfoTable.gd").new()
@onready var item_container = $ItemContainer
var emblems = ["fluffy_cat", "round_cat", "triangle_cat"]

var current_selection_id = 0
var current_selection: TextureButton = null  # Store the currently selected button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SceneTransition/ColorRect.color.a = 255
	$SceneTransition/AnimationPlayer.play("fade_out")
	generate_emblems()
	display_shop_items()

func generate_emblems() -> void:
	for i in 2:
		var size_of_dict = info_table.emblems.size()
		var random_key = info_table.emblems.keys()[randi() % size_of_dict]
		print("random_key: " + str(random_key))
		var emblem_name = random_key
		emblems[i] = emblem_name

func display_shop_items() -> void:
	var array_id = 0
	for emblem in emblems:
		print(info_table.emblems[emblem]["sprite"])
		
		# Create and configure the button
		var emblem_button = TextureButton.new()
		var emblem_texture = load(info_table.emblems[emblem]["sprite"])
		emblem_button.texture_normal = emblem_texture
		emblem_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
		emblem_button.custom_minimum_size = Vector2(200, 200)
		
		# Center the pivot for scaling
		emblem_button.set_pivot_offset(Vector2(100, 100))  # Half of custom_minimum_size

		# Store the button's ID in metadata
		emblem_button.set_meta("array_id", array_id)

		# Connect the button's "pressed" signal using a Callable
		emblem_button.connect("pressed", Callable(self, "_on_button_wrapper").bind(emblem_button))

		item_container.add_child(emblem_button)
		array_id += 1

func _on_button_wrapper(button: TextureButton) -> void:
	# Retrieve the ID stored in the button's metadata
	var id = button.get_meta("array_id")
	_on_button_pressed(button, id)

func _on_button_pressed(button: TextureButton, id: int) -> void:
	# Update the currently selected button
	if current_selection != null and current_selection != button:
		deselect_button(current_selection)
	
	# Mark the new button as selected
	current_selection = button
	current_selection_id = id
	selection_changed(id)
	
	var tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(1.1, 1.1), .1).set_trans(Tween.TRANS_BOUNCE)

func deselect_button(button: TextureButton) -> void:
	# Logic to deselect the button (if needed, e.g., change visuals)
	var tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(1, 1), .1).set_trans(Tween.TRANS_BOUNCE)
	print("Deselected:", button)

func selection_changed(id: int) -> void:
	# Logic for when the selection changes
	print("Selection changed to:", id)
	var emblem_name = emblems[current_selection_id]
	$"Description box".text = "[center]"+ str(info_table.emblems[emblem_name]["description"])


func _on_start_button_pressed() -> void:
	GameManager.player_emblems.append(emblems[current_selection_id])
	EffectsManager.recalculate_effects()
	EffectsManager.recalculate_effective_damage()
	get_tree().change_scene_to_file("res://Scenes/UI/ProgressionScreen.tscn")
