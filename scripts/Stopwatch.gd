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

#Also chatGPT
func timeStringToMilliseconds(time_str):
	# Split the time string into minutes, seconds, and milliseconds
	var time_parts = time_str.split(":")
	var minutes = time_parts[0].to_int()
	var seconds_and_milliseconds = time_parts[1].split(".")
	var seconds = seconds_and_milliseconds[0].to_int()
	var milliseconds = seconds_and_milliseconds[1].to_int()

	# Calculate the total milliseconds
	var total_milliseconds = (minutes * 60 + seconds) * 1000 + milliseconds

	return total_milliseconds
