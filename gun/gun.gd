extends Node2D

const BULLET_SCENE = preload("res://gun/bullet.tscn")
const SHELL_SCENE = preload("res://gun/shell.tscn")
var gun_scaling_factor = scale.x
var gun_sprite_offset_x
var recoil_force = 500
var bullets_per_shot = 3
var max_bullet_spread_angle = 40
var angle_between_bullets
var fire_rate = 2
var is_reloading = false

func _ready():
	gun_sprite_offset_x = $Sprite2D.position.x
	angle_between_bullets = max_bullet_spread_angle / bullets_per_shot
	$ReloadTimer.wait_time = 1.0 / fire_rate

func fire_bullet():
	if not is_reloading:
		is_reloading = true
		#print("Reloading...")
		$ReloadTimer.start()
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


func _on_reload_timer_timeout():
	#print("Shot ready!")
	instantiate_shell()
	is_reloading = false

func instantiate_shell():
	var max_shell_offset_angle = 45

	var shell = SHELL_SCENE.instantiate()
	get_tree().get_root().add_child(shell)
	shell.position = global_position
	
	var shell_direction
	
	if position.x > 0:
		shell_direction = position.orthogonal().normalized()
	else:
		shell_direction = -position.orthogonal().normalized()
		
	var random_angle_offset = randi_range(-max_shell_offset_angle / 2, max_shell_offset_angle / 2)
	shell_direction = shell_direction.rotated(deg_to_rad(random_angle_offset))
	shell.apply_impulse_in_direction(shell_direction)
