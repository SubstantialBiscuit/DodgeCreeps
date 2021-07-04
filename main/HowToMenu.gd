extends "res://main/scripts/SubMenuBase.gd"


func _ready():
	$Player.show()
	# Stop the jerk mob from moving
	get_node("JerkMob/MoveTimer").stop()
	# Stop mobs for dropping powerups in menu
	for mob in ["JerkMob", "Mob", "RockMob", "StayMob"]:
		get_node(mob).powerup_chance = 0
	$Powerups.play("default")
