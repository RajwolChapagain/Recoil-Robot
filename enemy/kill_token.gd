extends RigidBody2D

var fly_speed = 1000

signal kill_token_collected

func _on_player_detector_body_entered(body):
	if body.name == "Robot":
		emit_signal("kill_token_collected")
		queue_free()

func move_to_position(pos):
	if $CollisionShape2D.disabled == false:
		$CollisionShape2D.disabled = true
		gravity_scale = 0
		
	linear_velocity = position.direction_to(pos) * fly_speed
