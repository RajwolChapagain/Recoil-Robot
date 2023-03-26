extends RigidBody2D

const MOVE_SPEED = 400
const JUMP_SPEED = 700
var is_grounded = false
var distance_to_gun
var increment_angle_per_second_degrees = 100
var gun_rotation_angle = 0
var sensitivity = 4

func _ready():
	if $Gun != null:
		distance_to_gun = $Gun.position.length()

func _physics_process(delta):
		handle_gun_rotation(delta)
		
func _input(event):
	if event.is_action_pressed("fire_bullet"):
		if $Gun != null:
			$Gun.fire_bullet()
	
func _integrate_forces(state):
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		linear_velocity.x = - MOVE_SPEED

	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		linear_velocity.x = MOVE_SPEED
	
	if Input.is_action_just_pressed("jump"):
		if is_grounded:
			linear_velocity.y = -JUMP_SPEED
	
func _on_body_entered(body):
	if "platform" in body.get_groups():
		is_grounded = true
		
func _on_body_exited(body):
	if "platform" in body.get_groups():
		is_grounded = false

func handle_gun_rotation(physics_process_delta):
	if Input.is_action_pressed("rotate_gun_clockwise"):
		gun_rotation_angle += increment_angle_per_second_degrees * physics_process_delta * sensitivity
	if Input.is_action_pressed("rotate_gun_counter_clockwise"):
		gun_rotation_angle -= increment_angle_per_second_degrees * physics_process_delta * sensitivity
	
	if $Gun.position.x < 0:
		$Gun/Sprite2D.flip_v = true
	else:
		$Gun/Sprite2D.flip_v = false
		
	$Gun.position.x = distance_to_gun * cos(deg_to_rad(gun_rotation_angle))
	$Gun.position.y = distance_to_gun * sin(deg_to_rad(gun_rotation_angle))
	
	$Gun.rotation_degrees = gun_rotation_angle
	
