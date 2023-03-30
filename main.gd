extends Node2D

func _process(delta):
	get_tree().call_group("enemy", "set_target", $Robot)
