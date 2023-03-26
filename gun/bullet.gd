extends Area2D

var direction = Vector2.ZERO
const BULLET_SPEED = 50
var max_bullet_distance = 500
var initial_position

func _ready():
	initial_position = position
	
func _physics_process(delta):
	position += direction * BULLET_SPEED
	
	if initial_position.distance_to(position) > max_bullet_distance:
		queue_free()
		
