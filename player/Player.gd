extends Area2D

signal hit
signal new_powerup
signal using_powerup
signal powerup_used

export (PackedScene) var Bullet
export var speed = 300
var screen_size
var velocity : Vector2 = Vector2(0, 0)
var current_powerup = null
var invincible = false
var can_move = true
onready var eye : Sprite = get_node("Eye")


func _ready(): # Called when a node enters the scene tree
	screen_size = get_viewport_rect().size
	hide() # Hide player when game starts


func get_inputs():
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	# Normalize vector and multiply by speed so diagonal movement isn't faster
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		rotation = velocity.angle() + PI / 2
		$AnimatedSprite.play("swim")
	else:
		$AnimatedSprite.play("idle")
	
	# Shoot at mouse position
	if Input.is_action_pressed("shoot"):
		var target = get_global_mouse_position()
		shoot((target - position).normalized())
	
	# Use powerup
	if Input.is_action_just_pressed("use_powerup"):
		use_powerup()


# Shoots a bullet in the direction based on given vector
func shoot(direction):
	if not visible or not $ShotTimer.is_stopped():
		return # Don't shoot when hidden or timer is running
	var bullet = Bullet.instance()
	owner.add_child(bullet)
	# Start's bullet away from the player
	bullet.position = position + direction * 30
	bullet.rotation = direction.angle()
	$ShootSound.play()
	$ShotTimer.start()


func use_powerup():
	if current_powerup == null:
		return
	emit_signal("using_powerup", current_powerup.ability_time)
	current_powerup.ability()
	clear_powerup()


func clear_powerup():
	if not current_powerup == null:
		if current_powerup.in_progress:
			# Wait until current ability is over before clearing powerup
			yield(current_powerup, "ability_finished")
		# Delete's the powerup object and removes it from HUD
		if not current_powerup == null:
			current_powerup.queue_free()
		emit_signal("powerup_used")
		current_powerup = null

func _process(delta): # Ran every frame
	get_inputs()
	
	# Perform movement if allowed, multiply by delta to
	# keep movement consistent even if frame time changes
	if can_move:
		position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Follow cursor position with eye
	var angle = (get_viewport().get_mouse_position() - position).angle()
	# Adding 90 deg to account for eye pupil being offset in
	# relation to the Player node
	eye.rotation = angle - rotation + deg2rad(90)


func _on_Player_body_entered(_body):
	if not invincible:
		hide() # Player disappears after being hit
		clear_powerup()
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_Player_area_entered(area):
	# Delete existing powerup if there is one
	if is_instance_valid(current_powerup):
		# Don't allow player to collect a new powerup while ones ability is still running
		if current_powerup.in_progress:
			return
		clear_powerup()
	current_powerup = area
	current_powerup.collect()
	emit_signal("new_powerup")	
