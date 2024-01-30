extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D

func _process(_delta):
	_animated_sprite.play("Idle")

func _on_body_entered(body):
	if body.name == Utils.mg_playerName:
		Game.gold += 5
		var tweenPosition = get_tree().create_tween()
		tweenPosition.tween_property(self, "position", position - Vector2(0,25), 0.3)
		tweenPosition.parallel().tween_property(self, "scale", Vector2(), 0.3)
		tweenPosition.tween_callback(queue_free)
		
