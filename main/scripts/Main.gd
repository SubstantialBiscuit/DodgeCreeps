extends Node

const MAX_MENU_MOBS : int = 20
const DATA_FILE : String = "user://DodgeCreeps.dat"
var score : int
var high_score : int
var rng = RandomNumberGenerator.new()
var Explosion = preload("res://player/powerups/Explosion.tscn")


func _ready():
	rng.randomize()
	load_high_score()
	$HUD.update_high_score(high_score)
	set_process_input(false)


func game_over():
	set_process_input(false)
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
	set_process_input(true)
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


func explode(position : Vector2):
	$HUD.show_message("Debug: Explosion")
	var curr_explosion = Explosion.instance()
	add_child(curr_explosion)
	curr_explosion.position = position
	curr_explosion.max_radius = rand_range(10, 1000)
	curr_explosion.start()

func debug_inputs(event):
	if not OS.is_debug_build():
		return false
	if event.is_action_pressed("debug_invincible"):
		$Player.invincible = !$Player.invincible
		$HUD.show_message("Debug: Invincible = %s" % $Player.invincible)
		if $Player.invincible:
			$Player.get_node("AnimationPlayer").play("flash")
		else:
			$Player.get_node("AnimationPlayer").stop()
			$Player.get_node("AnimationPlayer").seek(0, true)
	elif event.is_action_pressed("debug_spawn_powerup"):
		$HUD.show_message("Debug: Spawning random powerup")
		spawn_powerup($Player.get_global_mouse_position())
	elif event.is_action_pressed("debug_explosion"):
		explode($Player.get_global_mouse_position())
	else:
		return false
	return true


func _input(event):
	if debug_inputs(event):
		get_tree().set_input_as_handled()
