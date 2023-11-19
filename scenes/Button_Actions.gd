extends HBoxContainer


func _ready():
	$Play.grab_focus()
	MusicController.play_music()
	
	AutoScript.load_game()
	pass

func _on_Play_pressed():
	#Put animation here
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/SwampStage.tscn")


func _on_Quit_pressed():
	get_tree().quit()
