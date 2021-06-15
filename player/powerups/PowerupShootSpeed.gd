extends "res://player/powerups/PowerupBase.gd"

export var shot_gap : float
onready var shot_timer = player.get_node("ShotTimer")
var default_shot_gap : float


func ability():
	hud.show_message('Shooting speed increased!')
	in_progress = true
	default_shot_gap = shot_timer.wait_time
	shot_timer.wait_time = shot_gap
	$PowerupTime.start()


func stop_ability():
	shot_timer.wait_time = default_shot_gap
	in_progress = false
	emit_signal("ability_finished")
