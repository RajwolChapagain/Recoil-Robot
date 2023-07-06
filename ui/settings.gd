extends Control

func _on_main_menu_button_down():
	visible = false
	save_sensitivity()
	save_acceleration_preference()
	save_music_volume()
	
func _on_visibility_changed():
	if visible:
		$VBoxContainer/HBoxContainer/HSlider.grab_focus()
		$VBoxContainer/HBoxContainer/HSlider.value = int(load_sensitivity())
		$VBoxContainer/HBoxContainer3/HSlider.value = int(load_music_volume())		
		$CheckButton.button_pressed = bool(load_acceleration_preference())

func save_sensitivity():
	var sensitivity = $VBoxContainer/HBoxContainer/HSlider.value
	var json_string = JSON.stringify(sensitivity)
	
	var save_file = FileAccess.open("res://sensitivity.save", FileAccess.WRITE)
	save_file.store_line(json_string)

func load_sensitivity():
	if not FileAccess.file_exists("res://sensitivity.save"):
		return 5
		
	var save_file = FileAccess.open("res://sensitivity.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var sensitivity = JSON.parse_string(json_string)
	
	return sensitivity

func save_acceleration_preference():
	var acceleration_preference = $CheckButton.button_pressed
	var json_string = JSON.stringify(acceleration_preference)
	
	var save_file = FileAccess.open("res://acceleration_preference.save", FileAccess.WRITE)
	save_file.store_line(json_string)

func load_acceleration_preference():
	if not FileAccess.file_exists("res://acceleration_preference.save"):
		return true
		
	var save_file = FileAccess.open("res://acceleration_preference.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var acceleration_preference = JSON.parse_string(json_string)
	
	return acceleration_preference

func save_music_volume():
	var volume = $VBoxContainer/HBoxContainer3/HSlider.value
	var json_string = JSON.stringify(volume)
	
	var save_file = FileAccess.open("res://music_volume.save", FileAccess.WRITE)
	save_file.store_line(json_string)

func load_music_volume():
	if not FileAccess.file_exists("res://music_volume.save"):
		return -20
		
	var save_file = FileAccess.open("res://music_volume.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var music_volume = JSON.parse_string(json_string)
	
	return music_volume

func _on_reset_button_down():
	$VBoxContainer/HBoxContainer/HSlider.value = 5
	$VBoxContainer/HBoxContainer3/HSlider.value = -20
	$CheckButton.button_pressed = true
