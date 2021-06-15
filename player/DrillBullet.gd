extends "res://player/Bullet.gd"


# Overwrite method so it can travel through anything
func _on_Bullet_body_entered(body):
	# Call hit method for any bodies that have it
	if body.has_method("bullet_hit"):
		body.bullet_hit("drill")

