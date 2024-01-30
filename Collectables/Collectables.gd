extends Node2D

var cherry = preload("res://Collectables/Cherry/cherry.tscn")

func _on_timer_timeout():
	var cherryTemp = cherry.instantiate()
	var rng = RandomNumberGenerator.new()
	var randomInt = rng.randi_range(10, 400)
	cherryTemp.position = Vector2(1400 + randomInt, 300)
	add_child(cherryTemp)
