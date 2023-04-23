extends Control
	
func set_kill_count_label(kill_count):
	$%KillCountLabel.text = str(kill_count)
	
func set_time_label(time_string):
	$%TimeLabel.text = str(time_string)
