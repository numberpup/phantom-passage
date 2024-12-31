extends Node2D
# This is the main node.
# Everything else (menus, gameplay scenes) will either replace or be
# instanced below this node.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Load and unload scenes.

# Handle global signals
