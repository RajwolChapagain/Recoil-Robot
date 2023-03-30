extends RigidBody2D

var move_speed = 200
var move_right = false
var target = self
var health_points = 40

func on_shot(impulse, direction, damage):
	apply_central_impulse(impulse * direction)
	
	health_points -= damage
	
	if health_points <= 0:
		die()

func _integrate_forces(state):
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
	target = new_target

func die():
	queue_free()


func _on_body_entered(body):
	if body.name == "Robot":
		on_robot_touched(body)
		
func on_robot_touched(robot):
	if robot.can_jump:
		robot.can_jump = false
	elif robot.can_move:
		robot.can_move = false
	else:
		robot.can_shoot = false
	
	die()
