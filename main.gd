extends Node2D

var kill_count = 0

func _ready():
	$Robot.connect("player_died", on_game_over)
	$EnemySpawner.connect("enemy_spawned", on_enemy_spawned)
	
func _process(delta):
	if $Robot != null:
		get_tree().call_group("enemy", "set_target", $Robot)
		

func on_enemy_spawned(enemy):
	enemy.connect("on_killed", on_enemy_killed)
	
func on_game_over():
	$GameOverScreen.display_game_over_panel(1, 2)

func on_enemy_killed():
	kill_count += 1
