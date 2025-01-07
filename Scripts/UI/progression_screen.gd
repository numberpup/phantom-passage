extends Control

@onready var floor_label = $FloorLabel
@onready var level_label = $LevelLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SceneTransition/ColorRect.color.a = 255
	$SceneTransition/AnimationPlayer.play("fade_out")
	floor_label.text = "[center]Floor " + str(GameManager.current_floor)
	level_label.text = "[center]Level " + str(GameManager.current_level)
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/LevelScreen.tscn")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
