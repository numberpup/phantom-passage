extends Node
# No scene, only a script.
# This is set as an Autoload (singleton) in Project Settings -> Globals -> Autoload.
# This will ensure it's always accessible from anywhere in the codebase.
# Therefore, this script is ideal for handling global data and variables.

# ----------------- #
# --- Variables --- #
# ----------------- #

# Run info
var runSeed = 0

# Progression variables
var current_floor = 1
var current_level = 1
var current_encounter = 1

# Player stats (changes nearly every move / turn)
var player_hp = 100
var player_hp_max = 100
var player_base_damage = 40
var player_damage_mult = 1
var effective_player_damage = 40

# placeholder
#var player_damage = 40

# Emblems, consumables, artifacts

# Stores emblems.
var player_emblems = [
	#"green_brick",
	#"red_brick",
	#"fluffy_cat"
]

var player_consumables = [] # Stores usable items.

var player_artifacts = [] # Stores acquired and active Artifacts.

# Board states and effects
var board_size = 4
var board_obstacle_count = 5

# Enemy state and effects
var enemy_health_max = 100
var enemy_health = 100
var enemy_attack = 10
var enemy_effects = []

# Turn management variables
@export var turn_time: float = 6

# ----------------- #
# --- Functions --- #
# ----------------- #

func reset():
	board_size = 4
	board_obstacle_count = 5
	player_base_damage = 40
	player_damage_mult = 1
	effective_player_damage = 40
	player_hp_max = 100
	player_hp = 100
	current_floor = 1
	current_level = 1
	current_encounter = 1
	player_emblems = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("GameManager is ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
