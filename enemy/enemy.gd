extends RigidBody2D

var move_speed = 200
var move_right = false
var target = self
var health_points = 40
var is_deploying = true

func _ready():
	gravity_scale = 0.4
	
func on_shot(impulse, direction, damage):
	#apply_central_impulse(impulse * direction)
	
	health_points -= damage
	
	if health_points <= 0:
		die()

func _integrate_forces(state):
	if is_deploying:
		return
		
	if move_right:
		linear_velocity.x = move_speed
	else:
		linear_velocity.x = -move_speed

func _physics_process(delta):
	move_to_target()
	
func move_to_target():
	if target.position.x - position.x > 0:
		move_right = true
	else:
		move_right = false

func set_target(new_target):
	if is_deploying:
		return
		
	target = new_target

func die():
	queue_free()


func _on_body_entered(body):
	if body.name == "Robot":
		if not is_deploying:
			on_robot_touched(body)
	elif body.is_in_group("platform"):
		if is_deploying:
			is_deploying = false
			gravity_scale = 1
		
func on_robot_touched(robot):
	if robot.can_jump:
		robot.disable_jump()
	elif robot.can_move:
		robot.disable_movement()
	else:
		robot.disable_shooting()
	
	die()
