extends RigidBody2D

func on_shot(impulse, direction):
	apply_central_impulse(impulse * direction)
