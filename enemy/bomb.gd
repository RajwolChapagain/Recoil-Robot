extends RigidBody2D

var explosion_force = 1000

func _on_body_entered(body):
		explode()
	
func explode():
	for body in $ExplosionArea.get_overlapping_bodies():
		if body.is_in_group("enemy") or body.name == "Robot":
			body.apply_central_impulse(explosion_force * global_position.direction_to(body.global_position))
			print(body.name)
	
	queue_free()
