extends Label

var current_time: int = 0;
var count: bool = true
	
func _process(delta):
	if not count: return;
	current_time += int(delta*1000_000)
	text = microsecondsToTimeString(current_time)

#From ChatGPT
func microsecondsToTimeString(microseconds):
	var total_seconds = int(microseconds / 1_000_000)
	var minutes = int(total_seconds / 60)
	var seconds = total_seconds % 60
	var milliseconds_remainder = int((microseconds % 1_000_000) / 1_000)

	# Format the time string
	var time_string = ("%0*d" % [2, minutes]) + ":" + ("%0*d" % [2, seconds]) + "." + ("%0*d" % [2, milliseconds_remainder])
	
	return time_string
