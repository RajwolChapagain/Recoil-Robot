extends Node2D

const BULLET_SCENE = preload("res://gun/bullet.tscn")
var gun_scaling_factor = scale.x
var gun_sprite_offset_x
var recoil_force = 500
var bullets_per_shot = 3
var max_bullet_spread_angle = 30
var angle_between_bullets

func _ready():
	gun_sprite_offset_x = $Sprite2D.position.x
	angle_between_bullets = max_bullet_spread_angle / bullets_per_shot

func fire_bullet():
	for i in range(bullets_per_shot):
		var bullet = BULLET_SCENE.instantiate()
		call_deferred("add_sibling_and_set_direction", bullet, i)

	give_parent_recoil()

func add_sibling_and_set_direction(bullet, bullet_index):
	add_sibling(bullet)
	
	
	bullet.direction = position.normalized()
	
	if bullet_index == 0:
		pass
	elif bullet_index == 1:
		bullet.direction = bullet.direction.rotated(deg_to_rad(angle_between_bullets))
	elif bullet_index == 2:
		bullet.direction = bullet.direction.rotated(deg_to_rad(-angle_between_bullets))
		
	
	bullet.position = position
	
	
func give_parent_recoil():
	get_parent().apply_impulse(-position.normalized() * recoil_force)
