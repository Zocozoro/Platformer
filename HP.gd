extends Label

# References
@onready var player = get_node("../../Player/Player")

func _process(_delta):
	self.text = "HP: " + str(player.HEALTH)
