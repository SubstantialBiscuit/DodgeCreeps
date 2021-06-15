extends Node

const MAX_MENU_MOBS : int = 20
var score

func _ready():
	randomize()	


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	# Spawn mobs in the menu background
	$MenuTimer.start()
	


func new_game():
	# Clear any mobs left from previous game and stop MenuTimer
	$MenuTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("powerups", "queue_free")
	# Reset score and intialise player
	score = 0
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	# Spawn boss mobs every 100s
	if score % 100 == 0:
		# Get random number for spawning
		var boss_num = randi() % int(floor(score / 100)) + 1
		var msg = 'Boss' if boss_num == 1 else '%s bosses' % boss_num
		$HUD.show_message(msg + ' incoming!')
		# Spawn bosses
		yield(get_tree().create_timer(0.5), "timeout")
		spawn_multiple(100) # Temp code until boss is implemented
	
	# As the score increases spawn mobs more often
	elif score >= 60:
		# Spawn additional mobs every 10 seconds (at least 2)
		if score % 10 == 0:
			var spawn_num = randi() % int(ceil(score / 20)) + 2
			spawn_multiple(spawn_num)
			$HUD.show_message(str(spawn_num) + ' more incoming!')


func spawn_multiple(num):
	# Spawns multiple mobs
	var count = 0
	while count < num:
		spawn_mob()
		count += 1


func spawn_mob():
	# Will spawn a random mob, chosen by the WeightedMobs node
	# Choose a random location of Path2D
	$MobPath/MobSpawnLocation.offset = randi()
	# Create a Mob instance and add it to the scene
	var mob = $MobsArray.choose_scene().instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction)
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


func _on_MobTimer_timeout():
	spawn_mob()


func _on_MenuTimer_timeout():
	# Spawn mobs while menu is active
	if len(get_tree().get_nodes_in_group("mobs")) <= MAX_MENU_MOBS:
		spawn_mob()


func spawn_powerup(position : Vector2):
	# Spawns random powerup at given position
	var powerup = $PowerupsArray.choose_scene().instance()
	call_deferred("add_child", powerup)
	powerup.position = position
