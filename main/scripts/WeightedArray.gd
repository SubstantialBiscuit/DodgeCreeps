# Class for choosing a scene for an array of scene based on probabilities
# provided in an array of weights, used for spawning mobs and powerups

extends Node


export (Array, PackedScene) var scenes
export (Array, int) var weights
var cum_weights : Array
var tot_weight : int


# Called when the node enters the scene tree for the first time.
func _ready():
	# Check if given arrays are the same length
	if scenes.size() != weights.size():
		push_error("The scenes and weights arrays are different lengths.")
	if scenes.size() == 0:
		push_warning("The scenes array is empty.")
	# Calculate cumulative weights and the total weights
	cum_weights = cum_sum()
	tot_weight = cum_weights[-1]


func cum_sum():
	# Create array of cumulative sums of values in weights
	var tot = 0
	var cum_sum : Array = []
	for i in weights:
		tot += i
		cum_sum.append(tot)
	return cum_sum


func choose_scene():
	# Chooses a scene based on the weights provided
	# Get random number between 1 and tot_weight
	var rand = randi() % tot_weight + 1
	var choice = 0
	# Selects the first scene where the random number is less than the cummulative
	# weight at that position
	for i in cum_weights:
		if rand <= i:
			return scenes[choice]
		choice += 1
