extends Control


func _on_restart_button_button_down():
	get_tree().reload_current_scene()
