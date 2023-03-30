extends Node2D

const ENEMY_SCENE = preload("res://enemy/enemy.tscn")
var spawn_rate = 0.2
var spawn_rate_increment = 0.2

func _ready():
	set_timer_wait_time()

func set_timer_wait_time():
	$SpawnRateTimer.wait_time = 1 / float(spawn_rate)
	
func _on_spawn_rate_timer_timeout():
	var enemy = ENEMY_SCENE.instantiate()
	add_child(enemy)

func _on_rate_increment_timer_timeout():
	spawn_rate += spawn_rate_increment
	set_timer_wait_time()
