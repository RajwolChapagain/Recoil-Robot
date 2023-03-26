extends Area2D

var direction = Vector2.ZERO
const BULLET_SPEED = 50

func _physics_process(delta):
	position += direction * BULLET_SPEED
