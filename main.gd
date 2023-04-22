extends Node2D

var kill_count = 0
var time_started

var game_over = false

func _ready():
	$Robot.connect("player_died", on_game_over)
	$EnemySpawner.connect("enemy_spawned", on_enemy_spawned)
	time_started = Time.get_ticks_msec()
	randomize()
	
func on_enemy_spawned(enemy):
	enemy.connect("on_killed", on_enemy_killed)
	enemy.connect("enemy_deployed", on_enemy_deployed)
	enemy.connect("kill_token_spawned", on_kill_token_spawned)
	
func on_game_over():
	if !game_over:
		game_over = true
		$GameOverScreen.display_game_over_panel(kill_count, (Time.get_ticks_msec() - time_started) / 1000)
		get_tree().call_group("enemy", "set_target", self)

func on_enemy_killed():
	pass
	
func on_enemy_deployed(enemy):
	if !game_over:
		enemy.set_target($Robot)

func on_kill_token_spawned(kill_token):
	kill_token.connect("kill_token_collected", on_kill_token_collected)
	
func on_kill_token_collected():
	kill_count += 1
