extends RigidBody2D

var initial_impulse = 600
	
func _physics_process(delta):
	$Sprite2D.modulate.a = $DestroyTimer.time_left / 2
	
func apply_impulse_in_direction(direction):
	apply_central_impulse(direction * initial_impulse)
	
func _on_destroy_timer_timeout():
	queue_free()
