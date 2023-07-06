extends Control

var PLAY_SCENE = load("res://main.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Buttons/Play.grab_focus()
	$Settings/MainMenu.connect("button_down", on_settings_close)
	
func _on_settings_button_down():
	$Settings.visible = true

func _on_play_button_down():
	get_tree().change_scene_to_packed(PLAY_SCENE)

func on_settings_close():
	$Buttons/Play.grab_focus()

func _on_quit_button_down():
	get_tree().quit()

func _on_main_menu_button_down():
	$CreditsPanel.visible = false
	$Buttons/Play.grab_focus()

func _on_credits_button_down():
	$CreditsPanel.visible = true


func _on_credits_panel_visibility_changed():
	if visible:
		$CreditsPanel/MainMenu.grab_focus()
