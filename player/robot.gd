extends RigidBody2D

const MOVE_SPEED = 400
const JUMP_SPEED = 800
var is_grounded = false
var distance_to_gun
var increment_angle_per_second_degrees = 100
var gun_rotation_angle = 0
var sensitivity = 4
var robot_without_pad = load("res://player/robot_without_pad.png")
var robot_without_pad_and_wheels = load("res://player/robot_without_pad_and_wheels.png")
var robot_inactive= load("res://player/robot_inactive.png")
var can_move = true
var can_jump = true
var can_shoot = true

signal player_died

func _ready():
	if $Gun != null:
		distance_to_gun = $Gun.position.length()

func _physics_process(delta):
	handle_gun_rotation(delta)
	check_if_fallen()
		
func _input(event):
	if event.is_action_pressed("fire_bullet"):
		if can_shoot:
			if $Gun != null:
				$Gun.fire_bullet()
	
func _integrate_forces(state):
	if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
		if can_move:
			linear_velocity.x = - MOVE_SPEED

	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
		if can_move:
			linear_velocity.x = MOVE_SPEED
	
	if Input.is_action_just_pressed("jump"):
		if can_jump:
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
	
func disable_jump():
	can_jump = false
	$Gun.recoil_force *= 1.8
	$Sprite2D.texture = robot_without_pad
	
func disable_movement():
	can_move = false
	$Gun.fire_rate *= 2
	$Gun.set_reload_time_using_bullets_per_second($Gun.fire_rate)
	$Sprite2D.texture = robot_without_pad_and_wheels

func disable_shooting():
	can_shoot = false
	on_death()

func check_if_fallen():
	if global_position.y > get_viewport_rect().size.y + 200:
		on_death()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	$FiveSecondDeathTimer.start()

func _on_visible_on_screen_notifier_2d_screen_entered():
	$FiveSecondDeathTimer.stop()

func _on_five_second_death_timer_timeout():
	on_death()

func on_death():
	$Sprite2D.texture = robot_inactive
	emit_signal("player_died")
