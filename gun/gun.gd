extends Node2D

const BULLET_SCENE = preload("res://gun/bullet.tscn")
#const SHELL_SCENE = preload("res://gun/shell.tscn")
var gun_scaling_factor = scale.x
var gun_sprite_offset_x
var recoil_force = 500
var bullets_per_shot = 1
var max_bullet_spread_angle = 0
var angle_between_bullets
var fire_rate = 2
var is_reloading = false
@onready var normal_gun_sprite = $Sprite2D.texture
var gun_reloading_sprite = load("res://gun/gun_reloading.png")

func _ready():
	gun_sprite_offset_x = $Sprite2D.position.x
	angle_between_bullets = max_bullet_spread_angle / bullets_per_shot
	set_reload_time_using_bullets_per_second(fire_rate)

func fire_bullet():
	if not is_reloading:
		is_reloading = true
		$Sprite2D.texture = gun_reloading_sprite
		$ReloadTimer.start()
		var bullet = BULLET_SCENE.instantiate()
		call_deferred("add_sibling_and_set_direction", bullet)

		give_parent_recoil()

func add_sibling_and_set_direction(bullet):
	get_tree().get_root().add_child(bullet)
	bullet.direction = position.normalized()
	bullet.position = global_position
		
func give_parent_recoil():
	get_parent().apply_impulse(-position.normalized() * recoil_force)


func _on_reload_timer_timeout():
	#instantiate_shell()
	is_reloading = false
	$Sprite2D.texture = normal_gun_sprite

#func instantiate_shell():
#	var max_shell_offset_angle = 45
#
#	var shell = SHELL_SCENE.instantiate()
#	get_tree().get_root().add_child(shell)
#	shell.position = global_position
#
#	var shell_direction
#
#	if position.x > 0:
#		shell_direction = position.orthogonal().normalized()
#	else:
#		shell_direction = -position.orthogonal().normalized()
#
#	var random_angle_offset = randi_range(-max_shell_offset_angle / 2, max_shell_offset_angle / 2)
#	shell_direction = shell_direction.rotated(deg_to_rad(random_angle_offset))
#	shell.apply_impulse_in_direction(shell_direction)

func set_reload_time_using_bullets_per_second(bullets_per_second):
	$ReloadTimer.wait_time = 1.0 / bullets_per_second
	
