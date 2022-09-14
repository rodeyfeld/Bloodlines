extends KinematicBody2D


var parent = null

func configure(s = null, reposition_parent=false):
	if s and reposition_parent:
		s.position.x = position.x
		s.position.y = position.y
		
func _on_AnimatedSprite_animation_finished():
	queue_free()
