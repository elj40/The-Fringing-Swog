extends Node2D

var music = load("res://assets/sounds/music.wav")

func _ready():
	pass


func play_music():
	$Music.stream = music
	$Music.play()
