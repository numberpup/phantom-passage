extends Node



var floors = [
	#empty
	[],
		#floor 1
	[
		#empty
		[],
		#level 1
		[
			#empty encounter
			"",
			#encounter 1
			"nice_torso",
			#encounter 2
			"suspicious_balloon",
			#encounter 3
			"red_guy",
			# temporary 4th encounter
			"funky_beetle"
		],
		#level 2,
		[],
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
