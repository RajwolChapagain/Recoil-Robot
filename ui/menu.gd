extends Control

const PLAY_SCENE = preload("res://main.tscn")

func _on_settings_button_down():
	$Settings.visible = true

func _on_play_button_down():
	get_tree().change_scene_to_packed(PLAY_SCENE)
