extends RigidBody2D

var explosion_force = 1000
var explosion_radius_display_duration = 0.8

func _on_body_entered(body):
		explode()
	
func explode():
	for body in $ExplosionArea.get_overlapping_bodies():
		if body.is_in_group("enemy") or body.name == "Robot" or body.is_in_group("kill_token"):
			body.apply_central_impulse(explosion_force * global_position.direction_to(body.global_position))
			
	$Sprite2D.visible = false
	$BombRadiusSprite.visible = true
	call_deferred("freeze_body_and_disable_collision_shape")
	await get_tree().create_timer(explosion_radius_display_duration).timeout
	queue_free()

func freeze_body_and_disable_collision_shape():
	freeze = true
	$BombCollisionShape.disabled = true
