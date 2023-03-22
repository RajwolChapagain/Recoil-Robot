extends RigidBody2D

const MOVE_SPEED = 400
const JUMP_SPEED = 700
var is_grounded = false
var facing_right = true

func _process(delta):
	if $Gun != null:
		$Gun.look_at(get_global_mouse_position())
		
func _integrate_forces(state):
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		linear_velocity.x = - MOVE_SPEED
		
		if facing_right:
			facing_right = false
	
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		linear_velocity.x = MOVE_SPEED
		
		if not facing_right:
			facing_right = true
			
	if Input.is_action_just_pressed("jump"):
		if is_grounded:
			linear_velocity.y = -JUMP_SPEED
	
	if Input.is_action_just_pressed("fire_bullet"):
		if $Gun != null:
			$Gun.fire_bullet()

func _on_body_entered(body):
	if "platform" in body.get_groups():
		is_grounded = true
		
func _on_body_exited(body):
	if "platform" in body.get_groups():
		is_grounded = false
