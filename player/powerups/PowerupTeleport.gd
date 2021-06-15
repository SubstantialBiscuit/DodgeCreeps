extends "res://player/powerups/PowerupBase.gd"

var teleport_to : Vector2

func ability():
	hud.show_message('Teleporting!')
	in_progress = true
	player.invincible = true
	player.can_move = false
	# Get teleport position
	teleport_to = get_viewport().get_mouse_position()
	# Run the shrink animation and wait for it to finish before teleporting
	player.get_node("AnimationPlayer").play("shrink")
	yield(player.get_node("AnimationPlayer"), "animation_finished")
	player.position = teleport_to
	# Run grow animation and set to orig_scale once it's done
	player.get_node("AnimationPlayer").play("grow")
	$PowerupTime.start()


func stop_ability():
	player.invincible = false
	player.can_move = true
	emit_signal("ability_finished")
