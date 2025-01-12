extends Node
# IS NOW A GLOBAL AUTOLOAD/SINGLETON

@onready var emblem_names = GameManager.player_emblems
@onready var info_table = preload("res://Scripts/DataProcessors/InfoTable.gd").new()

var effects_dict = {
	# specifically modifies BASE damage, pre-multipliers
	"damage_10": {
		"activate": func(): damage_increase(10),
		"deactivate": func(): damage_increase(-10),
	},
	"damage_20": {
		"activate": func(): damage_increase(20),
		"deactivate": func(): damage_increase(-20),
	},
	"damage_40": {
		"activate": func(): damage_increase(40),
		"deactivate": func(): damage_increase(-40),
	},
	"mult_4": {
		"activate": func(): mult_increase(4),
		"deactivate": func(): mult_increase(-4),
	},
	"tile_damage_1": {
		"activate": func(): tile_damage(1),
		"deactivate": func(): tile_damage(-1),
	},
	"obst_increase_1": {
		"activate": func(): obst_increase(1),
		"deactivate": func(): obst_increase(-1),
	}
}

func _ready() -> void:
	# CALLS WHEN LOADED
	for emblem_name in emblem_names:
		var effect = info_table.emblems[emblem_name]["effect"]
		print(effects_dict[effect])
		effects_dict[effect]["activate"].call()

func deactivate_effects() -> void:
		# CALLS WHEN LOADED
	for emblem_name in emblem_names:
		var effect = info_table.emblems[emblem_name]["effect"]
		print(effects_dict[effect])
		effects_dict[effect]["deactivate"].call()

# EFFECT FUNCTIONS
func damage_increase(amount) -> void:
	print("damage increase called")
	GameManager.player_base_damage += amount
	recalculate_effective_damage()
	
	# EFFECT FUNCTIONS
func mult_increase(amount) -> void:
	GameManager.player_damage_mult += amount
	recalculate_effective_damage()

func damage_mults(amount) -> void:
	GameManager.player_base_damage *= amount
	recalculate_effective_damage()

func mult_mults(amount) -> void:
	GameManager.player_damage_mult *= amount
	recalculate_effective_damage()

func tile_damage(amount) -> void:
	var tile_number = (GameManager.board_size * GameManager.board_size) - GameManager.board_obstacle_count
	damage_increase(tile_number)

func obst_increase(amount) -> void:
	GameManager.board_obstacle_count += amount

func recalculate_effects() -> void:
	for emblem_name in emblem_names:
		print("emblem name: " + emblem_name)
		var effect = info_table.emblems[emblem_name]["effect"]
		print(effects_dict[effect])
		effects_dict[effect]["activate"].call()

func recalculate_effective_damage() -> void:
	GameManager.effective_player_damage = GameManager.player_base_damage * GameManager.player_damage_mult
	print("Calculated damage: " + str(GameManager.effective_player_damage))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
