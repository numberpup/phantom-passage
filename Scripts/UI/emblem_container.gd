extends VBoxContainer

@onready var emblem_names = GameManager.player_emblems
@onready var info_table = preload("res://Scripts/DataProcessors/InfoTable.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_emblems()

func display_emblems() -> void:
	for emblem_name in emblem_names:
		var emblem_sprite = load(info_table.emblems[emblem_name]["sprite"])
		var emblem_rect = TextureRect.new()
		emblem_rect.texture = emblem_sprite
		emblem_rect.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		emblem_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		self.add_child(emblem_rect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
