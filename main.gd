extends Node2D

func _ready():
	$Robot.connect("player_died", on_game_over)
	
func _process(delta):
	if $Robot != null:
		get_tree().call_group("enemy", "set_target", $Robot)
	
func on_game_over():
	$GameOverScreen.visible = true
