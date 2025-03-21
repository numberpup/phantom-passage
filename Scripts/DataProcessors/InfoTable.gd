extends Node
# ----------------------------------------------- #
# ---------------- DICTIONARIES ----------------- #
# ----------------------------------------------- #

# ------------------ FRIENDS ------------------- #
var emblems: Dictionary = {
	"green_brick": {
		"description": "Adds 10 to base player damage.",
		"sprite": "res://Assets/BrickSprites/GreenBrick.png",
		"effect": "damage_10",
		"display_name": "Green Brick"
	},
	"red_brick": {
		"description": "Adds 4 to base damage multiplier.",
		"sprite": "res://Assets/BrickSprites/RedBrick.png",
		"effect": "mult_4",
		"display_name": "Red Brick"
	},
	"pink_brick": {
		"description": "Increases number of inactive tiles on board by 1.",
		"sprite": "res://Assets/BrickSprites/PinkBrick.png",
		"effect": "obst_increase_1",
		"display_name": "Pink Brick"
	},
	"fluffy_cat": {
		"description": "Adds 20 to base player damage.",
		"sprite": "res://Assets/EmblemSprites/FluffyCat.png",
		"effect": "damage_20",
		"display_name": "Fluffy Cat"
	},
	"round_cat": {
		"description": "Adds 4 to base damage multiplier.",
		"sprite": "res://Assets/EmblemSprites/RoundCat.png",
		"effect": "mult_4",
		"display_name": "Round Cat"
	},
	"triangle_cat": {
		"description": "Adds 1 to base damage for each active tile in completed puzzle.",
		"sprite": "res://Assets/EmblemSprites/TriangleCat.png",
		"effect": "tile_damage_1",
		"display_name": "Triangle Cat"
	}
}

# ---------------- CONSUMABLES ------------------ #
var consumables: Dictionary = {
	
}

# ------------------ UPGRADES ------------------- #
var artifacts: Dictionary = {
	
}

# ------------------ ENEMIES -------------------- #
const enemies: Dictionary = {
	"nice_torso": {
		"hp": 100,
		"atk": 40,
		"sprite": "res://Assets/EnemySprites/NiceTorso.png",
		"sprite_x_dim": 32,
		"sprite_y_dim": 32,
		"sprite_sheet_cols": 3,
		"sprite_sheet_rows": 4,
		"sprite_count": 10,
		"sprite_offset": 0,
		"size_mult": 4,
		"speed_mult": 2,
		"name": "Nice Torso"
	},
		"funky_beetle": {
		"hp": 100,
		"atk": 40,
		"sprite": "res://Assets/EnemySprites/FunkyBeetle.png",
		"sprite_x_dim": 64,
		"sprite_y_dim": 96,
		"sprite_sheet_cols": 4,
		"sprite_sheet_rows": 3,
		"sprite_count": 12,
		"sprite_offset": -100,
		"size_mult": 3,
		"speed_mult": 2,
		"name": "Funky Beetle"
	},
		"suspicious_balloon": {
		"hp": 100,
		"atk": 40,
		"sprite": "res://Assets/EnemySprites/SuspiciousBalloon.png",
		"sprite_x_dim": 32,
		"sprite_y_dim": 32,
		"sprite_sheet_cols": 4,
		"sprite_sheet_rows": 4,
		"sprite_count": 14,
		"sprite_offset": 0,
		"size_mult": 4,
		"speed_mult": 2,
		"name": "Suspicious Balloon"
	},
		"red_guy": {
		"hp": 100,
		"atk": 40,
		"sprite": "res://Assets/EnemySprites/RedGuy.png",
		"sprite_x_dim": 32,
		"sprite_y_dim": 64,
		"sprite_sheet_cols": 2,
		"sprite_sheet_rows": 1,
		"sprite_count": 2,
		"sprite_offset": -50,
		"size_mult": 3.5,
		"speed_mult": .5,
		"name": "Red Guy"
	},
}

# ----------------- MINIBOSSES ------------------ #
var mini_bosses: Dictionary = {
	
}

# ------------------- BOSSES -------------------- #
var bosses: Dictionary = {
	
}

# ------------------- KINGS --------------------- #
var kings: Dictionary = {
	# The King of the Wailing Tombs
	"wailing_tombs": {
		"hp": 10000,
		"atk": 100,
		"effects": [],
		"sprite": "",
		"name": "The King of the Wailing Tombs"
	},
	"shattered_twilight": {
		"hp": 10000,
		"atk": 100,
		"effects": [],
		"sprite": "",
		"name": "The King of the Wailing Tombs"
	},
}

# ------------------- EFFECTS --------------------- #
var effects: Dictionary = {
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
