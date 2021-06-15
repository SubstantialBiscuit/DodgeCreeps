extends "res://mobs/Mob.gd"


var direction : float


func _on_MoveTimer_timeout():
	linear_velocity = Vector2.ZERO
	# Pick a random direction and face it
	direction = rotation + rand_range(-PI / 6, PI / 6)
	rotation = direction
	$WaitTimer.start()


func _on_WaitTimer_timeout():
	# Move with a random velocity in direction
	linear_velocity = Vector2(rand_range(min_speed, max_speed), 0)
	linear_velocity = linear_velocity.rotated(direction)
	$MoveTimer.start()
