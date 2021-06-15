extends "res://player/powerups/PowerupBase.gd"


export (PackedScene) var Bullet
export (PackedScene) var DrillBullet

# Overwrite this function with the powerups ability
func ability():
	hud.show_message('Drill bullets activated!')
	in_progress = true
	player.Bullet = DrillBullet
	$PowerupTime.start()
	

func stop_ability():
	player.Bullet = Bullet
	in_progress = false
	emit_signal("ability_finished")
