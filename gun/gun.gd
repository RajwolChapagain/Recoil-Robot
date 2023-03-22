extends Node2D

const BULLET_SCENE = preload("res://gun/bullet.tscn")
var gun_scaling_factor = scale.x
var gun_sprite_offset_x

func _ready():
	gun_sprite_offset_x = $Sprite2D.position.x

func fire_bullet():
	var bullet = BULLET_SCENE.instantiate()
	call_deferred("add_sibling_and_set_direction", bullet)

func add_sibling_and_set_direction(bullet):
	add_sibling(bullet)
	
	var gun_sprite_global_position = to_global($Sprite2D.position)
	var parent_global_position = get_parent().position
	
	var point_direction = parent_global_position.direction_to(gun_sprite_global_position)

	bullet.position = position
	bullet.direction = point_direction
