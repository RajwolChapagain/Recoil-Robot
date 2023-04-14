extends Control

func _on_restart_button_button_down():
	get_tree().reload_current_scene()

func display_game_over_panel(kills, time):
	visible = true
	$%Kills.text += str(kills)
	$%Time.text += str(time)
