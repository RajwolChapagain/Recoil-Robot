extends Control

func _on_main_menu_button_down():
	visible = false
	save_sensitivity()
	
func _on_visibility_changed():
	if visible:
		$HBoxContainer/HSlider.grab_focus()
		$HBoxContainer/HSlider.value = int(load_sensitivity())

func save_sensitivity():
	var sensitivity = $HBoxContainer/HSlider.value
	var json_string = JSON.stringify(sensitivity)
	
	var save_file = FileAccess.open("res://sensitivity.save", FileAccess.WRITE)
	save_file.store_line(json_string)

func load_sensitivity():
	if not FileAccess.file_exists("res://sensitivity.save"):
		return 3
		
	var save_file = FileAccess.open("res://sensitivity.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var sensitivity = JSON.parse_string(json_string)
	
	return sensitivity
