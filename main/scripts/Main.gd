extends Node

const MAX_MENU_MOBS : int = 20
const DATA_FILE : String = "user://DodgeCreeps.dat"
var score : int
var high_score : int
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	load_high_score()
	$HUD.update_high_score(high_score)


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	var new_high = check_high_score()
	# Game over message and sound
	$HUD.show_game_over(new_high)
	$Music.stop()
	$DeathSound.play()
	# Spawn mobs in the menu background
	$MenuTimer.start()


func check_high_score():
	# Check and update high score
	if score > high_score:
		high_score = score
		save_high_score()
		$HUD.update_high_score(high_score)
		return true
	return false


func save_high_score():
	# Saves the high score in DATA_FILE
	var file = File.new()
	file.open(DATA_FILE, File.WRITE)
	file.store_16(high_score)
	file.close()


func load_high_score():
	# Loads high score from DATA_FILE
	var file = File.new()
	if not file.file_exists(DATA_FILE):
		return 0
	file.open(DATA_FILE, File.READ)
	high_score = file.get_16()
	file.close()
	return high_score


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
	# Spawn extra horde of mobs every 100s
	if score % 50 == 0:
		# Get random number for spawning (at least 10)
		var horde_num = rng.randi_range(10, score / 2)
		if horde_num < 20:
			horde_num += 20
		$HUD.show_message('Horde incoming!')
		# Spawn bosses
		yield(get_tree().create_timer(0.5), "timeout")
		spawn_multiple(horde_num)
	
	# As the score increases spawn mobs more often
	elif score >= 35:
		# Spawn additional mobs every 10 seconds (at least 2)
		if score % 10 == 0:
			var spawn_num = rng.randi_range(2, score / 10)
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
