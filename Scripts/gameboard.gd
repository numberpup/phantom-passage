extends Node2D

##
# EXPORTED VARIABLES
##
@export var tile_size: int = 150
@export var tile_padding: int = 40

@export var active_color: Color = Color(.95, .85, .95)         # pink for active tiles
@export var inactive_color: Color = Color(.3, .3, .3) # Gray for obstacles/inactive
@export var visited_color: Color = Color(.95, .9, .4)        # Yellow when swiped

@export var fail_flash_color: Color = Color(.9, .3, .2)     # Red
@export var success_flash_color: Color = Color(.3, .9, .4)  # green

@export var flash_duration: float = 0.3  # Fast fade time

@export var min_board_size: int = 4
@export var max_board_size: int = 6
@export var min_obstacle_count: int = 3
@export var max_obstacle_count: int = 5

##
# SIGNALS
##
signal board_clear
signal board_fail
signal turn_start

##
# Import script to generate new boards
var BoardGenerator = preload("res://Scripts/board_generator.gd")

var board_model: Array = [
	[1, 1, 1, 1, 1, 1],
	[1, 0, 1, 1, 0, 1],
	[1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1],
	[1, 0, 1, 1, 0, 1],
	[1, 1, 1, 1, 1, 1],
]

# References to tile nodes
var tiles: Array = []

# Dictionary used like a "visited set": Key = tile Node2D
var visited_tiles: Dictionary = {}

# Whether we're currently dragging/swiping
var dragging: bool = false

# Used to ignore repeated touches on the same tile
var last_tile_touched: Node2D = null

# Whether the board is interactable
var board_interactable: bool = true

# function triggers when turn_end signal is recieved by board
func _turn_end() -> void:
	pass

func reset_board() -> void:
	var generator = BoardGenerator.new()
	board_model = generator.generate_board(GameManager.board_size, GameManager.board_obstacle_count)
	_center_board_if_needed()
	create_grid_from_model(board_model)

func _ready() -> void:
	reset_board()

	# Ensure this node can receive input events
	set_process_input(true)


##
# CENTER THE BOARD IF THE PARENT IS A CONTROL
##
func _center_board_if_needed() -> void:
	var parent_node = get_parent()
	if parent_node is Control:
		var parent_size: Vector2 = parent_node.get_rect().size
		var row_count = board_model.size()
		var col_count = board_model[0].size()

		var total_width: float = float(col_count) * float(tile_size + tile_padding)
		var total_height: float = float(row_count) * float(tile_size + tile_padding)

		position = ((parent_size - Vector2(total_width, total_height)) / 2).floor()


##
# CREATE THE GRID FROM board_model
##
func create_grid_from_model(model: Array) -> void:
	# Remove old tiles if any
	for tile in tiles:
		tile.queue_free()
	tiles.clear()

	for row in range(model.size()):
		var row_data = model[row]
		for col in range(row_data.size()):
			var tile_value = row_data[col]  # 0 or 1

			# Create a Node2D for each cell
			var tile_node = Node2D.new()
			tile_node.position = Vector2(
				col * (tile_size + tile_padding),
				row * (tile_size + tile_padding)
			)

			# Store is_active in metadata
			tile_node.set_meta("row", row)
			tile_node.set_meta("col", col)
			tile_node.set_meta("is_active", tile_value == 1)

			# Visual: ColorRect
			var color_rect = ColorRect.new()
			color_rect.size = Vector2(tile_size, tile_size)
			if tile_value == 1:
				color_rect.color = active_color
			else:
				color_rect.color = inactive_color

			tile_node.add_child(color_rect)
			add_child(tile_node)
			tiles.append(tile_node)

##
# INPUT HANDLING (MOUSE OR TOUCH)
##
func _input(event: InputEvent) -> void:
	if not board_interactable:
		return # Ignore input if the board is not interactable

	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			# Start drag
			dragging = true
			visited_tiles.clear()
			last_tile_touched = null

			# Touch the tile at mouse/touch position
			var tile = get_tile_at_position(event.position)
			if tile:
				_touch_tile(tile)
		else:
			# Release
			if dragging:
				dragging = false
				# Check board status (success/fail)
				await _check_board_status()

	elif (event is InputEventScreenDrag or event is InputEventMouseMotion) and dragging:
		# Ongoing drag
		var tile_dragged = get_tile_at_position(event.position)
		if tile_dragged:
			_touch_tile(tile_dragged)


##
# HANDLE TOUCHING/DRAGGING ONTO A TILE
##
func _touch_tile(tile: Node2D) -> void:
	if tile == last_tile_touched:
		return

	# ENFORCE ADJACENCY: 4-direction Manhattan distance
	if last_tile_touched != null:
		var last_row = last_tile_touched.get_meta("row")
		var last_col = last_tile_touched.get_meta("col")
		var row = tile.get_meta("row")
		var col = tile.get_meta("col")

		if abs(last_row - row) + abs(last_col - col) != 1:
			return  # Ignore if non-adjacent

	# Already visited => fail
	if visited_tiles.has(tile):
		dragging = false
		await _check_board_status(true)
		return

	# Inactive => fail
	if not tile.get_meta("is_active"):
		dragging = false
		await _check_board_status(true)
		return

	# Mark tile visited
	visited_tiles[tile] = true

	# Change color to visited
	var color_rect = tile.get_child(0) as ColorRect
	color_rect.color = visited_color

	last_tile_touched = tile


##
# CHECK IF BOARD IS CLEAR OR FAIL
##
func _check_board_status(failed: bool = false):
	dragging = false

	if failed:
		# Flash red, then fade each tile back to original color in parallel
		var fail_tween = await _flash_board(fail_flash_color)
		await fail_tween.finished
		emit_signal("board_fail")
		return

	# If not an immediate fail, check if all active tiles visited
	var total_active = 0
	for tile in tiles:
		if tile.get_meta("is_active"):
			total_active += 1

	if visited_tiles.size() == total_active:
		# SUCCESS
		var success_tween = await _flash_board(success_flash_color)
		await success_tween.finished
		emit_signal("board_clear")
		reset_board()
	else:
		# FAIL (some active tiles not visited)
		var fail_tween_2 = await _flash_board(fail_flash_color)
		await fail_tween_2.finished
		emit_signal("board_fail")


##
# FLASH THE ENTIRE BOARD, THEN FADE BACK TO EACH TILE'S ORIGINAL COLOR
##
func _flash_board(flash_color: Color) -> Tween:
	var tween: Tween = create_tween()

	# 1) Instantly set them to the flash color
	for tile in tiles:
		var color_rect = tile.get_child(0) as ColorRect
		color_rect.color = flash_color
	
	# 2) Tween all back to active/inactive in parallel
	for tile in tiles:
		var color_rect = tile.get_child(0) as ColorRect
		var is_tile_active = tile.get_meta("is_active")

		var final_color: Color
		if is_tile_active:
			final_color = active_color
		else:
			final_color = inactive_color
		
		# Instead of .parallel() or .as_parallel(), use set_parallel(true).
		var property_tweener = tween.tween_property(
			color_rect,
			"color",
			final_color,
			flash_duration
		)

	return tween


##
# FIND WHICH TILE (IF ANY) IS UNDER THE GIVEN SCREEN POSITION
##
func get_tile_at_position(pos: Vector2) -> Node2D:
	var local_pos = to_local(pos)
	for tile in tiles:
		var tile_pos = tile.position
		var rect = Rect2(tile_pos, Vector2(tile_size, tile_size))
		if rect.has_point(local_pos):
			return tile
	return null

##
# Enable and disable board interaction
##
func disable_board_interaction():
	board_interactable = false

func enable_board_interaction():
	board_interactable = true
