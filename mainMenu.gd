extends Node2D

var skip_title_screen = false

# Hack for easier debug
func _enter_tree():
	if skip_title_screen:
		get_tree().change_scene_to_file("res://world.tscn")

func _ready():
	#Utils.saveGame()
	Utils.loadGame()

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
