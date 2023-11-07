extends Node2D

export(NodePath) var complete_panel;
export(NodePath) var complete_time;
export(NodePath) var complete_nextstage;
export(NodePath) var current_time;

func _ready():
	complete_panel = $StageUI/PanelContainer
	complete_time = $StageUI/PanelContainer/VBoxContainer/Time
	complete_nextstage = $StageUI/PanelContainer/VBoxContainer/HBoxContainer/NextStage
	current_time = $StageUI/HBoxContainer/Stopwatch
	complete_panel.visible = false

func finish_level():
	$Swog.won = true
		
	complete_panel.visible = true
	complete_nextstage.grab_focus()
	
	current_time.count = false
	complete_time.text = "Your time was " + current_time.text
	
	var time_to_finish = current_time.timeStringToMilliseconds(current_time.text)
	
	if time_to_finish < AutoScript.stage1_best_time:
		AutoScript.stage1_best_time = time_to_finish
		
	print(AutoScript.stage1_best_time)

func _on_Finish_body_entered(body):
	if "Swog" in body.name:
		yield(get_tree().create_timer(0.5), "timeout")
		finish_level()

func _on_NextStage_pressed():
	print("Next Stage")
	get_tree().change_scene("res://scenes/Stage1.tscn")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")


func _on_Reset_pressed():
	get_tree().change_scene("res://scenes/Stage1.tscn")
	get_tree().paused = false
	current_time.current_time = 0


func _on_Pause_pressed():
	get_tree().paused = not get_tree().paused
