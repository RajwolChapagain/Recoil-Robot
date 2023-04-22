extends RigidBody2D

signal kill_token_collected

func _on_player_detector_body_entered(body):
	if body.name == "Robot":
		emit_signal("kill_token_collected")
		queue_free()
