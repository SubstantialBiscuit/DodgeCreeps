extends Area2D

signal ability_finished

onready var player = get_tree().get_root().get_node("Main/Player")
onready var hud = get_tree().get_root().get_node("Main/HUD")
onready var ability_time : float = $PowerupTime.wait_time
var collected : bool = false
var in_progress = false
var start_vel
var elapsed_time : float = 0


func _ready():
	# Pick a random direction
	start_vel = Vector2.UP.rotated(rand_range(0, 2 * PI))	
	# Fade the powerup in
	$Fade.play("fade in")
	yield($Fade, "animation_finished")
	$CollisionShape2D.disabled = false
	$StayTime.start()


func spiral_powerup(delta):
	# Spiral outwards
	elapsed_time += delta
	var angle = lerp_angle(PI, 0, elapsed_time)
	var speed = lerp(0, 10, elapsed_time)
	position += start_vel.rotated(angle) * speed * delta


func _physics_process(delta):
	if not collected:
		spiral_powerup(delta)


func _on_StayTime_timeout():
	$Fade.play("fade out")
	yield($Fade, "animation_finished")
	if not collected:
		call_deferred("queue_free")


func collect():
	collected = true
	$Sprite.hide()
	$IdleParticles.emitting = false
	$CollisionShape2D.set_deferred("disabled", true)
	$CollectParticles.emitting = true
	$CollectSound.play()
	$StayTime.stop()
	# The player scene will delete the powerup


# Overwrite this function with the powerups ability
func ability():
	hud.show_message('Base powerup used!')
	emit_signal("ability_finished")

func stop_ability():
	pass # Function to stop any continuous abilities

func _on_PowerupTime_timeout():
	stop_ability()
