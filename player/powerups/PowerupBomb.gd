extends "res://player/powerups/PowerupBase.gd"

export var explosion_time := 1.5
export var explosion_radius := 300.0
export var message : String
onready var main = get_tree().get_root().get_node("Main")


func activate_position():
	# Func to return position to activate bomb overwritten by Nuke
	return player.get_global_mouse_position()


func ability():
	# Get instance of explosion from Main scene
	var curr_explosion = main.Explosion.instance()
	main.add_child(curr_explosion)
	curr_explosion.position = activate_position()
	curr_explosion.explosion_time = explosion_time
	curr_explosion.max_radius = explosion_radius
	$PowerupTime.start(explosion_time)
	in_progress = true
	hud.show_message(message)
	curr_explosion.start()


func stop_ability():
	emit_signal("ability_finished")

