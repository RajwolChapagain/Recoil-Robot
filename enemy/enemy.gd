extends RigidBody2D

var move_speed = 200
var move_right = false
var target = self

func on_shot(impulse, direction):
	apply_central_impulse(impulse * direction)

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

func set_target(target):
	self.target = target

