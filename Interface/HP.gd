extends Label

func _process(_delta):
	self.text = "HP: " + str(Game.playerHP)
