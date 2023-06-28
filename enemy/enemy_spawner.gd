extends Node2D

const ENEMY_SCENE = preload("res://enemy/enemy.tscn")
const MAX_ENEMY_PER_SECOND = 1
var spawn_rate = 0.2
var spawn_rate_increment = 0.05
var max_x_coordinate_spawn = 2160
var camera_zoom = 0.8 #get this from the main scene's camera
var spawn_y_offset = 200
var rate_increase_interval = 20

var interval_between_waves = 5
var current_minimum_enemy_count = 1
var maximum_minimum_enemy_count = 10
var current_maximum_enemy_count = 1
var interval_between_enemies = 0.5
var enemy_count_in_current_wave = 1
var enemies_spawned_this_wave = 0
var minimum_time_between_enemies = 1
var maximum_time_between_enemies = 3

signal enemy_spawned(enemy)


func pick_random_spawn_position():
	var x = randi_range(-240, max_x_coordinate_spawn)
	var y = 0 - spawn_y_offset
	
	return Vector2(x, y)

	
func stop_spawning():
	$WaveIntervalTimer.stop()
	$EnemySpawnTimer.stop()

func _on_wave_interval_timer_timeout():
	start_wave()

func start_wave():
	enemies_spawned_this_wave = 0
	enemy_count_in_current_wave = randi_range(current_minimum_enemy_count, current_maximum_enemy_count)
	print(enemy_count_in_current_wave)
	spawn_enemy()
	$EnemySpawnTimer.start()
	
func end_wave():
	$EnemySpawnTimer.stop()
	enemies_spawned_this_wave = 0
	if current_minimum_enemy_count != maximum_minimum_enemy_count:
		if current_minimum_enemy_count == current_maximum_enemy_count:
			current_maximum_enemy_count *= 2
		current_minimum_enemy_count += 1
	$WaveIntervalTimer.start()
		
func spawn_enemy():
	if enemies_spawned_this_wave == enemy_count_in_current_wave:
		end_wave()
		return
		
	var enemy = ENEMY_SCENE.instantiate()
	add_child(enemy)
	enemy.global_position = pick_random_spawn_position()
	emit_signal("enemy_spawned", enemy)
	enemies_spawned_this_wave += 1
	$EnemySpawnTimer.wait_time = randf_range(minimum_time_between_enemies, maximum_time_between_enemies)
	$EnemySpawnTimer.start()

func _on_enemy_spawn_timer_timeout():
	spawn_enemy()
