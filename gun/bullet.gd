extends Area2D

var direction = Vector2.ZERO
const BULLET_SPEED = 50
var max_bullet_distance = 500
var initial_position
var min_bullet_impact_force = 100
var max_bullet_impact_force = 300

func _ready():
	initial_position = position
	
func _physics_process(delta):
	position += direction * BULLET_SPEED
	
	if initial_position.distance_to(position) > max_bullet_distance:
		queue_free()
		


func _on_body_entered(body):
	if body.is_in_group("shootable"):
		body.on_shot(get_damage_based_on_distance(), position.normalized())
		queue_free()
	
func get_damage_based_on_distance():
	var damage = (min_bullet_impact_force - max_bullet_impact_force) * (initial_position.distance_to(position)) / max_bullet_distance + max_bullet_impact_force
	return damage
