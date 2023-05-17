extends Node2D

const ENEMY_SCENE = preload("res://enemy/enemy.tscn")
const MAX_ENEMY_PER_SECOND = 1
var spawn_rate = 0.2
var spawn_rate_increment = 0.05
var max_x_coordinate_spawn = 2160
var camera_zoom = 0.8 #get this from the main scene's camera
var spawn_y_offset = 200
var rate_increase_interval = 20

signal enemy_spawned(enemy)

func _ready():
	$RateIncrementTimer.wait_time = rate_increase_interval
	set_timer_wait_time()

func set_timer_wait_time():
	$SpawnRateTimer.wait_time = 1 / float(spawn_rate)
	
func _on_spawn_rate_timer_timeout():
	var enemy = ENEMY_SCENE.instantiate()
	add_child(enemy)
	enemy.global_position = pick_random_spawn_position()
	emit_signal("enemy_spawned", enemy)

func _on_rate_increment_timer_timeout():
	spawn_rate += spawn_rate_increment
	spawn_rate = clamp(spawn_rate, 0, MAX_ENEMY_PER_SECOND)
	$IncreaseLabel.visible = true
	$IncreaseLabel/LabelAppearTimer.start()
	set_timer_wait_time()

func pick_random_spawn_position():
	var x = randi_range(-240, max_x_coordinate_spawn)
	var y = 0 - spawn_y_offset
	
	return Vector2(x, y)


func _on_label_appear_timer_timeout():
	$IncreaseLabel.visible = false
	
func stop_spawning():
	$SpawnRateTimer.stop()
	$RateIncrementTimer.stop()
