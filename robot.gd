extends RigidBody2D

func _physics_process(delta):
	apply_central_force(Vector2(1000, 0))
