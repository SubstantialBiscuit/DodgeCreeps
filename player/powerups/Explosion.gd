extends Area2D


var elapsed_time := 0.0
export var max_radius := 100.0
export var explosion_time := 2.0
onready var shape = get_node("ExplosionShape")
onready var sound = get_node("ExplosionSound")
onready var particles = get_node("ExplosionParticles")
onready var timer := get_node("Timer")
var in_progress = false


func start():
	particles.lifetime = 1.2 * explosion_time
	timer.start(particles.lifetime)
	# Make particles move slightly faster than area
	particles.process_material.set(
		"initial_velocity", 1.1 * (max_radius / explosion_time)
	)
	particles.amount = max_radius * 8
	particles.emitting = true
	in_progress = true
	sound.play()


func stop():
	sound.stop()
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_progress:
		elapsed_time += delta
		var radius = lerp(0, max_radius, elapsed_time / explosion_time)
		if radius > max_radius:
			in_progress = false
			shape.disabled = true
			shape.shape.set("radius", 0)
		shape.shape.set("radius", radius)


func _on_Explosion_body_entered(body):
	if body.has_method("kill"):
		body.kill()


func _on_Timer_timeout():
	stop()
