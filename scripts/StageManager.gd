extends Node2D

export(String) var next_stage;

var complete_panel;
var complete_time;
var complete_nextstage;
var current_time;
var best_time;

func _ready():
	complete_panel = $StageUI/PanelContainer
	complete_time = $StageUI/PanelContainer/VBoxContainer/Time
	best_time = $StageUI/PanelContainer/VBoxContainer/BestTime
	complete_nextstage = $StageUI/PanelContainer/VBoxContainer/HBoxContainer/NextStage
	current_time = $StageUI/HBoxContainer/Stopwatch
	complete_panel.visible = false

func finish_level():
	$Swog.won = true
		
	complete_panel.visible = true
	complete_nextstage.grab_focus()
	
	current_time.count = false
	complete_time.text = "Time:  " + current_time.text
	
	
	var time_to_finish = current_time.timeStringToMilliseconds(current_time.text)*1000
	var current_stage = get_tree().current_scene.name
	
	print(current_stage);
	
	if "Swamp" in current_stage:
		AutoScript.swamp_best_time = time_to_finish if time_to_finish<AutoScript.swamp_best_time else AutoScript.swamp_best_time;
		best_time.text = "Best: " + current_time.microsecondsToTimeString(AutoScript.swamp_best_time)
	elif "Desert" in current_stage:
		AutoScript.desert_best_time = time_to_finish if time_to_finish<AutoScript.desert_best_time else AutoScript.desert_best_time	
		best_time.text = "Best: " + current_time.microsecondsToTimeString(AutoScript.desert_best_time)
	elif "Mountain" in current_stage:
		AutoScript.mountain_best_time = time_to_finish if time_to_finish<AutoScript.mountain_best_time else AutoScript.mountain_best_time
		best_time.text = "Best: " + current_time.microsecondsToTimeString(AutoScript.mountain_best_time)
		
	AutoScript.save()

func _on_Finish_body_entered(body):
	if "Swog" in body.name:
		yield(get_tree().create_timer(0.5), "timeout")
		finish_level()

func _on_NextStage_pressed():
	print("Next Stage")
# warning-ignore:return_value_discarded
	get_tree().change_scene(next_stage)


func _on_MainMenu_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Reset_pressed():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	get_tree().paused = false
	current_time.current_time = 0


func _on_Pause_pressed():
	get_tree().paused = not get_tree().paused
