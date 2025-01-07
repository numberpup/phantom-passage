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
var player_hp = 50
var player_base_damage = 40
var player_damage_mult = 1
var player_damage = 40

# Friends, consumables, upgrades
var player_party = [] # Stores Friends.
var player_consumables = [] # Stores usable items.
var player_upgrades = [] # Stores acquired and active Artifacts.

# Board states and effects
var board_size = 4
var board_obstacle_count = 5

# Enemy state and effects
var enemy_health_max = 100
var enemy_health = 100
var enemy_attack = 10
var enemy_effects = []

# Turn management variables
@export var turn_time: float = 15.0

# ----------------- #
# --- Functions --- #
# ----------------- #

# Called when the node enters the scene tree for the first time.
func _ready():
	print("GameManager is ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
