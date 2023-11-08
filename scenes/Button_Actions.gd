extends HBoxContainer


func _ready():
	$Play.grab_focus()
	pass


func _on_Play_pressed():
	#Put animation here
	get_tree().change_scene("res://scenes/DesertStage.tscn")


func _on_Quit_pressed():
	get_tree().quit()
