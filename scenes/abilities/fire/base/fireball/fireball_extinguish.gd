extends AnimatedSprite

func _on_fireball_extinguish_animation_finished():
	queue_free()
