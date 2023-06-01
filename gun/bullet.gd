extends Area2D

var direction = Vector2.ZERO
const BULLET_SPEED = 50
var max_bullet_distance = 4000
var initial_position
var min_bullet_impact_force = 1200
var max_bullet_impact_force = 2000
var damage = 40

func _ready():
	initial_position = position
	
func _physics_process(delta):
	position += direction * BULLET_SPEED
	
	if initial_position.distance_to(position) > max_bullet_distance:
		queue_free()
		
func _on_body_entered(body):
	if body.is_in_group("shootable"):
		body.on_shot(damage, direction, damage)
		queue_free()
	elif body.is_in_group("platform"):
		queue_free()
