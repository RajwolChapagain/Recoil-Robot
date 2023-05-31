extends Control

func _on_main_menu_button_down():
	visible = false
	
func _on_visibility_changed():
	if visible:
		$HBoxContainer/HSlider.grab_focus()
