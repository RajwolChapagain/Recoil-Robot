extends Control

const MENU_SCENE = preload("res://ui/menu.tscn")

func _on_restart_button_button_down():
	get_tree().reload_current_scene()

func display_game_over_panel(kills, time):
	$Panel/VBoxContainer/Buttons/RestartButton.grab_focus()
	var tween = get_tree().create_tween()
	$Panel.scale = Vector2(0.2, 0.2)
	tween.tween_property($Panel, "scale", Vector2(1, 1), 0.2)         
	visible = true
	$%Kills.text += " " + str(kills)
	#$%Time.text += str(time)
	
		
	if kills > load_kills_and_time()["kills"]:
		save_kills_and_time(kills, time)
		
	var high_scores = load_kills_and_time()
	$%BestKills.text += " " + str(high_scores["kills"])
	#$%AccompanyingTime.text += str(high_scores["time"])

func save_kills_and_time(kills, time):
	var score_dict = {"kills" : kills, "time" : time}
	var json_string = JSON.stringify(score_dict)
	
	var save_file = FileAccess.open("res://high_scores.save", FileAccess.WRITE)
	save_file.store_line(json_string)

func load_kills_and_time():
	if not FileAccess.file_exists("res://high_scores.save"):
		return {"kills" : 0, "time" : 0}
		
	var save_file = FileAccess.open("res://high_scores.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var score_dict = JSON.parse_string(json_string)
	
	return score_dict
	
func _on_quit_button_button_down():
	get_tree().quit()

func _on_menu_button_button_down():
	get_tree().change_scene_to_packed(MENU_SCENE)

func _input(event):
	if event.is_action_pressed("pause") and name == "PausedPanel":
		if get_tree().paused:
			visible = false
			get_tree().set_deferred("paused", false)
