extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationFadeDiamond.play("Fade_In_Diamond")
	$AnimationFadeText.play("Fade_In_Hackleton")
	$AnimationSpinDiamond.play("Spin_Diamond")
	await get_tree().create_timer(1.7).timeout
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
