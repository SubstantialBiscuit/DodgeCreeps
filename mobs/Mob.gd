# Base node for all mobs

extends RigidBody2D

# A random speed will be chose between min and max
export var min_speed : int
export var max_speed : int
# A random scale will be chosen between min and max when the mob is spawned
export var min_scale : float
export var max_scale : float
# Chance to drop a powerup on death
export var powerup_chance : float


var rand_scale : Vector2
var dying : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialise a random scale
	var rand = rand_range(min_scale, max_scale)
	rand_scale = Vector2(rand, rand)
	set_scale(rand_scale)


func _integrate_forces(_state):
	# Sets the scale everytime the physics simulation runs
	set_scale(rand_scale)


func _on_VisibilityNotifier2D_screen_exited():
	if not dying:
		queue_free()


func bullet_hit(_bullet_type : String):
	# Called by the bullet when it hits
	kill()


func kill():
	dying = true
	$AnimatedSprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$DeathParticles.emitting = true
	$DeathSound.play()
	# Wait until death particles have finished before destroying
	var time = $DeathParticles.lifetime / $DeathParticles.speed_scale
	# Decide whether to spawn powerup
	if randf() < powerup_chance:
		get_tree().get_root().get_node("Main").spawn_powerup(position)
	yield(get_tree().create_timer(time), "timeout")
	queue_free()

