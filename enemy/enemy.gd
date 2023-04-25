extends RigidBody2D

var move_speed = 200
var move_right = false
var target = self
var health_points = 40
var is_deploying = true
var approximate_bottom_screen_position = 1296
var bomb_scene = load("res://enemy/bomb.tscn")
var kill_token_scene = load("res://enemy/kill_token.tscn")
var red_eye_sprite = load("res://enemy/enemy.png")
var green_eye_sprite = load("res://enemy/enemy_green_eye.png")
var touched_player = false

signal enemy_deployed(enemy)
signal on_killed
signal kill_token_spawned(kill_token)
signal bomb_summoned(bomb)

func _ready():
	gravity_scale = 0.4
	
func on_shot(impulse, direction, damage):	
	health_points -= damage
	
	if health_points <= 0:
		emit_signal("on_killed")
		
		if !touched_player:
			call_deferred("spawn_kill_token")
		die()

func spawn_kill_token():
	var kill_token = kill_token_scene.instantiate()
	get_tree().get_root().add_child(kill_token)
	kill_token.position = global_position
	emit_signal("kill_token_spawned", kill_token)
	
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
			on_deployment_complete()
			
		
func on_robot_touched(robot):
	if touched_player:
		return
		
	if robot.can_jump:
		robot.disable_jump()
	elif robot.can_move:
		robot.disable_movement()
	else:
		robot.disable_shooting()
	
	move_speed = 0
	$Sprite2D.texture = green_eye_sprite
	touched_player = true
	
func check_if_below_screen():
	if position.y > approximate_bottom_screen_position:
		die()
		summon_bomb()
		
func summon_bomb():
	var bomb = bomb_scene.instantiate()
	get_tree().get_root().add_child(bomb)
	emit_signal("bomb_summoned", bomb)
	bomb.position = pick_random_spawn_position()
	
func pick_random_spawn_position():
	var x = randi_range(-240, 2160) #True for 0.8x zoom on Camera
	var y = -200
	
	return Vector2(x, y)

func set_move_right(is_moving_right):
	move_right = is_moving_right

func on_deployment_complete():
	is_deploying = false
	gravity_scale = 1
	emit_signal("enemy_deployed", self)
	$Sprite2D.texture = red_eye_sprite
