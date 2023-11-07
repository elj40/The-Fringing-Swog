extends CanvasLayer

signal next_stage_pressed;
signal menu_stage_pressed;

func _ready():
	$MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/NextStage.grab_focus()
	pass


func _on_NextStage_pressed():
	emit_signal("next_stage_pressed")


func _on_MainMenu_pressed():
	emit_signal("menu_stage_pressed")
