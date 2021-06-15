extends "res://mobs/Mob.gd"


# Calculate which wall is going to be hit


func bullet_hit(bullet_type : String):
	if bullet_type == 'drill':
		kill()
