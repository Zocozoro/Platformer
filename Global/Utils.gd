extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"gold": Game.gold,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	
func loadGame():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)	
		if file.eof_reached():
			return
			
		var current_line = JSON.parse_string(file.get_line())
		if not current_line:
			return

		Game.playerHP = current_line["playerHP"]
		Game.gold = current_line["gold"]
