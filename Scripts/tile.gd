extends TextureRect

# identifiers
var tile_id = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("I exist")
	self.modulate = Color(255, 255, 255)





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Mouse has entered the building
func _on_mouse_entered() -> void:
	self.modulate = Color(0, 0, 0)
	#pass # Replace with function body.
