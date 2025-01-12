extends Node

var enemy_damage_multipliers = [
	# empty
	[],
	# floor 1
	[
		# empty
		[],
		# encounter 1
		1,
		# encounter 2
		2,
		# encounter 3
		3
	],
	# floor 2
	[
		# empty
		[],
		# encounter 1
		4,
		# encounter 2
		5,
		# encounter 3
		6
	],
	# floor 3
	[
		# empty
		[],
		# encounter 1
		7,
		# encounter 2
		8,
		# encounter 3
		9
	],
	# floor 4
	[
		# empty
		[],
		# encounter 1
		10,
		# encounter 2
		11,
		# encounter 3
		12
	],
	# floor 5
	[
		# empty
		[],
		# encounter 1
		13,
		# encounter 2
		14,
		# encounter 3
		15
	]
]

var floors = [
	# empty
	[],
		# floor 1
	[
		# empty
		[],
		# level 1
		[
			# empty encounter
			"",
			# encounter 1
			"nice_torso",
			# encounter 2
			"suspicious_balloon",
			# encounter 3
			"red_guy",
		],
		# level 2,
		[
			# empty encounter
			"",
			# encounter 1
			"suspicious_balloon",
			# encounter 2
			"red_guy",
			# encounter 3
			"funky_beetle"
		],
		# level 3,
		[
			# empty encounter
			"",
			# encounter 1
			"suspicious_balloon",
			# encounter 2
			"red_guy",
			# encounter 3
			"funky_beetle"
		],
		#etc
	],
	#floor 2,
	[],
	#etc
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _generate_encounters(seed: int) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
