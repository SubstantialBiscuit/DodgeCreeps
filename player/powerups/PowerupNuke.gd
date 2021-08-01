extends "res://player/powerups/PowerupBase.gd"


func ability():
	in_progress = true
	hud.show_message('Nuked!')
	get_tree().call_group("mobs", "kill")
	$ExplosionSound.play()


func _on_ExplosionSound_finished():
	emit_signal("ability_finished")

