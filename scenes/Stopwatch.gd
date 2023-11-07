extends Label

var start_time;
var current_time;

func _ready():
	start_time = Time.get_ticks_usec()
	current_time = start_time
	print(start_time)
	pass
	
func _process(_delta):
	current_time = Time.get_ticks_usec()
	text = microsecondsToTimeString(current_time-start_time)

#From ChatGPT
func microsecondsToTimeString(microseconds):
	var total_seconds = int(microseconds / 1_000_000)
	var minutes = int(total_seconds / 60)
	var seconds = total_seconds % 60
	var milliseconds_remainder = int((microseconds % 1_000_000) / 1_000)

	# Format the time string
	var time_string = ("%0*d" % [2, minutes]) + ":" + ("%0*d" % [2, seconds]) + "." + ("%0*d" % [2, milliseconds_remainder])
	
	return time_string
