extends "res://player/powerups/PowerupBase.gd"


func ability():
	hud.show_message('Invincibility activated!')
	in_progress = true
	player.invincible = true
	player.get_node("AnimationPlayer").play("flash")
	$PowerupTime.start()


func stop_ability():
	player.invincible = false
	player.get_node("AnimationPlayer").stop()
	in_progress = false
	emit_signal("ability_finished")
