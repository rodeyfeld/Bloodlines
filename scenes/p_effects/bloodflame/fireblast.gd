extends Node2D


func configure(s):
	var look_at = s.get_global_mouse_position()
	var _direction = (look_at  - s.position);
	var new_angle =  atan2(_direction.y, _direction.x)
	self.rotate(new_angle * -1)



func _on_Timer_timeout():
	queue_free()
