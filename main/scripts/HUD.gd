extends CanvasLayer

signal start_game

onready var powerup_tween = $PowerupBackground/Tween
onready var player = get_tree().get_root().get_node("Main/Player")

# Display a temporary message
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


# Displays game over screen then start screen
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	# Make a one-shot timer and to give slight delay 
	# before showing start button
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_Player_new_powerup():
	var powerup = player.current_powerup
	var sprite_path = powerup.get_node("Sprite").texture.resource_path
	$PowerupBackground/PowerupSprite.texture = load(sprite_path)


func _on_Player_powerup_used():
	$PowerupBackground/PowerupFlash.stop()
	$PowerupBackground/PowerupSprite.texture = null
	$PowerupBackground/PowerupSprite.rect_scale = Vector2(1, 1)


func _on_Player_using_powerup(power_time):
	# Shrink the powerup symbol based on length of ability
	powerup_tween.interpolate_property(
		$PowerupBackground/PowerupSprite, "rect_scale",
		Vector2(1, 1), Vector2.ZERO, power_time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	powerup_tween.start()
	# Flash the powerup symbol
	$PowerupBackground/PowerupFlash.play("flash")
