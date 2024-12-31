extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SceneTransition/ColorRect.color.a = 255
	$SceneTransition/AnimationPlayer.play("fade_out")
	await get_tree().create_timer(0.3).timeout
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# START BUTTON PRESSED
func _on_button_pressed() -> void:
	#$SceneTransition/ColorRect.color.a = 0
	#$SceneTransition/AnimationPlayer.play("fade_in")
	#await get_tree().create_timer(0.3).timeout
	
	# change scene
	get_tree().change_scene_to_file("res://Scenes/LevelScreen.tscn")
