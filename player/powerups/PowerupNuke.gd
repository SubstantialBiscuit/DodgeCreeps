extends "res://player/powerups/PowerupBomb.gd"


func _ready():
	# Set explosion radius to viewport size
	explosion_radius = main.get_viewport().size.length()


func activate_position():
	# Start nuke at centre of window
	return get_viewport_rect().size / 2
