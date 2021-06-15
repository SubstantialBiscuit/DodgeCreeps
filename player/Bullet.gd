extends Area2D

export var speed : int = 700


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	# Call hit method for any bodies that have it
	if body.has_method("bullet_hit"):
		body.bullet_hit("normal")
	# Destroy the bullet when it collides with anything
	queue_free()
