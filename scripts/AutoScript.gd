extends Node

var swamp_best_time:int = 99999999 
var desert_best_time:int = 99999999 
var mountain_best_time:int = 99999999 

var loaded : bool = false;
func save():
	var save_file = File.new()
	save_file.open("user://savegame.json", File.WRITE)
	
	var data = "["+String(swamp_best_time)+","+String(desert_best_time)+","+String(mountain_best_time)+"]";
	save_file.store_line(data)

	save_file.close()


func load_game():
	if loaded: return
	
	var save_file = File.new()
	
	print(save_file.file_exists("user://savegame.json"))
	
	if not save_file.file_exists("user://savegame.json"):
		return; # Error! We don't have a save to load.
		
	save_file.open("user://savegame.json", File.READ)
	print(save_file.get_as_text())
	var line = save_file.get_as_text()
	print(line)
	var data = parse_json("[14800000, 12299000, 27580000]");
	
	print(data)
	
	swamp_best_time = data[0]
	desert_best_time = data[1]
	mountain_best_time = data[2]
	
	save_file.close()
	loaded = true
