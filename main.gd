extends Node2D

var kill_count = 0
var time_started

var game_over = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Robot.connect("player_died", on_game_over)
	$Robot/VisibleOnScreenNotifier2D.connect("screen_exited", on_player_exit_screen)
	$Robot/VisibleOnScreenNotifier2D.connect("screen_entered", on_player_enter_screen)	
	$EnemySpawner.connect("enemy_spawned", on_enemy_spawned)
	$Robot/Gun.connect("gun_fired", on_gun_fired)
	time_started = Time.get_ticks_msec()
	randomize()

func _physics_process(delta):
	if !game_over:
		update_hud_time()
		if !$Robot.can_move:
			get_tree().call_group("kill_token", "move_to_position", $Robot.position)

func on_player_exit_screen():
	$HUD/FiveSecondRuleLabel.visible = true	
	
func on_player_enter_screen():
	$HUD/FiveSecondRuleLabel.visible = false
		
func on_gun_fired(bullet_direction):
	shake_camera(-bullet_direction.x * 5, -bullet_direction.y * 5, 0.1)
	
func update_hud_time():
	$HUD/FiveSecondRuleLabel.text = str(int($Robot/FiveSecondDeathTimer.time_left))
	
func on_enemy_spawned(enemy):
	enemy.connect("on_killed", on_enemy_killed)
	enemy.connect("enemy_deployed", on_enemy_deployed)
	enemy.connect("kill_token_spawned", on_kill_token_spawned)
	enemy.connect("bomb_summoned", on_bomb_summoned)
	
func on_bomb_summoned(bomb):
	bomb.connect("bomb_exploded", on_bomb_exploded)
	
func on_bomb_exploded():
	shake_camera(30, 30, 0.5)
	
func on_game_over():
	if !game_over:
		game_over = true
		$GameOverScreen.display_game_over_panel(kill_count, (Time.get_ticks_msec() - time_started) / 1000)
		get_tree().call_group("enemy", "set_target", self)
		$EnemySpawner.stop_spawning()

func on_enemy_killed():
	shake_camera(10, 10, 0.15)
	Input.start_joy_vibration(0, 0.5, 1, 0.15)
	
func on_enemy_deployed(enemy):
	if !game_over:
		enemy.set_target($Robot)

func on_kill_token_spawned(kill_token):
	kill_token.connect("kill_token_collected", on_kill_token_collected)
	
func on_kill_token_collected():
	kill_count += 1
	$HUD.set_kill_count_label(kill_count)

func shake_camera(max_x_displacement, max_y_displacement, duration):
	var initial_camera_offset = Vector2(960, 540)
	
	while duration > 0:
		var rand_x_displacement = randf_range(-max_x_displacement, max_x_displacement)
		var rand_y_displacement = randf_range(-max_y_displacement, max_y_displacement)
		$Camera2D.offset = initial_camera_offset + Vector2(rand_x_displacement, rand_y_displacement)
		duration -= get_physics_process_delta_time()
		await get_tree().physics_frame
	
	$Camera2D.offset = initial_camera_offset
		
	
