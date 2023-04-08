extends Node2D

const ENEMY_SCENE = preload("res://enemy/enemy.tscn")
var spawn_rate = 0.2
var spawn_rate_increment = 0.1
var max_x_coordinate_spawn
var camera_zoom = 0.8 #get this from the main scene's camera
var spawn_y_offset = 200
var rate_increase_interval = 20

func _ready():
	$RateIncrementTimer.wait_time = rate_increase_interval
	set_timer_wait_time()
	max_x_coordinate_spawn = get_viewport_rect().size.x + (1 - camera_zoom) * get_viewport_rect().size.x

func set_timer_wait_time():
	$SpawnRateTimer.wait_time = 1 / float(spawn_rate)
	
func _on_spawn_rate_timer_timeout():
	var enemy = ENEMY_SCENE.instantiate()
	add_child(enemy)
	enemy.position = pick_random_spawn_position()

func _on_rate_increment_timer_timeout():
	spawn_rate += spawn_rate_increment
	set_timer_wait_time()

func pick_random_spawn_position():
	var x = randi_range(0, max_x_coordinate_spawn)
	var y = 0 - spawn_y_offset
	
	return Vector2(x, y)
