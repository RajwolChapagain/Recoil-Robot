extends RigidBody2D

var move_speed = 200
var move_right = false
var target = self
var health_points = 40
var is_deploying = true
var approximate_bottom_screen_position = 1296
var bomb_scene = load("res://enemy/bomb.tscn")

signal enemy_deployed(enemy)
signal on_killed

func _ready():
	gravity_scale = 0.4
	
func on_shot(impulse, direction, damage):	
	health_points -= damage
	
	if health_points <= 0:
		emit_signal("on_killed")
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
	check_if_below_screen()
	
func move_to_target():
	if target.position.x - position.x > 0:
		if move_right == false:
			if $DirectionChangeDelay.is_stopped():
				$DirectionChangeDelay.start()
				await $DirectionChangeDelay.timeout
				move_right = true
	else:
		if move_right == true:
			if $DirectionChangeDelay.is_stopped():
				$DirectionChangeDelay.start()
				await $DirectionChangeDelay.timeout
				move_right = false

func set_target(new_target):
	target = new_target

	if target.position.x - position.x > 0:
		if move_right == false:
				move_right = true
	else:
		if move_right == true:
				move_right = false
				
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
			emit_signal("enemy_deployed", self)
		
func on_robot_touched(robot):
	if robot.can_jump:
		robot.disable_jump()
	elif robot.can_move:
		robot.disable_movement()
	else:
		robot.disable_shooting()
	
	die()

func check_if_below_screen():
	if position.y > approximate_bottom_screen_position:
		die()
		summon_bomb()
		
func summon_bomb():
	var bomb = bomb_scene.instantiate()
	get_tree().get_root().add_child(bomb)
	
	bomb.position = pick_random_spawn_position()
	
func pick_random_spawn_position():
	var x = randi_range(-240, 2160) #True for 0.8x zoom on Camera
	var y = -200
	
	return Vector2(x, y)

func set_move_right(is_moving_right):
	move_right = is_moving_right
