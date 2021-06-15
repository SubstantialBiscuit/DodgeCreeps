extends "res://mobs/Mob.gd"

onready var screen_size = get_viewport_rect().size
export var edge_time : float
# Variables to keep track of whether we are turning away from a wall or checking
# if we are near one
var turning : bool = false
var turn_time : float = 0.0
var start_vel = null
var final_vel = null



# Bounce the mob off the nearest edge (when less than edge_time away)
func bounce_edge():
	# Get distance to top/bottom of screen
	var y_dist : float
	if linear_velocity.y > 0:
		y_dist = screen_size.y - position.y
	else:
		y_dist = position.y
	# Get distance from the left/right
	var x_dist : float
	if linear_velocity.x > 0:
		x_dist = screen_size.x - position.x
	else:
		x_dist = position.x
	# Get times
	var y_time : float
	var x_time : float
	if linear_velocity.y == 0:
		y_time = INF
	else:
		y_time = y_dist / abs(linear_velocity.y)
	if linear_velocity.x == 0:
		x_time = INF
	else:
		x_time = x_dist / abs(linear_velocity.x)
	# Bounce off "edge" if nearer than edge_time
	if x_time < y_time:
		if x_time < edge_time:
			return linear_velocity.bounce(Vector2.RIGHT)
	else:
		if y_time < edge_time :
			return linear_velocity.bounce(Vector2.UP)


func _process(delta):
	# Check if we are performing a turn and lerp to new velocity
	if turning:
		turn_time += delta
		linear_velocity = lerp(start_vel, final_vel, turn_time / 2)
		# Once turn count is one the turn is finished so reset
		if turn_time >= 2:
			turn_time = 0
			turning = false
		return
	# Check distance from edge and get a bounce vector if close enough
	final_vel = bounce_edge()
	if final_vel == null:
		return # final_vel is null if mob isn't close enough to an edge
	# Set variables ready to perform a turn and normalise final_vel
	start_vel = linear_velocity
	final_vel = final_vel.normalized() * start_vel.length()
	# Add some randomness to the final velocity
	final_vel = final_vel.rotated(rand_range(-PI / 4, PI / 4))
	turning = true


func _integrate_forces(state):
	# Call parent function then rotate if turning
	._integrate_forces(state)
	rotation = linear_velocity.angle()
