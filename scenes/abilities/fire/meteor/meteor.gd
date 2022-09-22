extends Node

var meteor = load("res://scenes/p_effects/bloodflame/meteor.tscn")

var cooldown = 1
var cooldown_active = false


onready var timer = $Timer

func execute(s_pos, d_pos):
	if !cooldown_active:
		start_cooldown(cooldown)
		var m = meteor.instance()
		m.configure(s_pos, d_pos)
		add_child(m)
#		m.look_at(d_pos - s_pos)
		var _direction = (d_pos  - s_pos);
		var new_angle =  atan2(_direction.y, _direction.x)
		m.rotate(new_angle)
func start_cooldown(duration):
	self.cooldown_active = true
	timer.start(duration)
	
func _on_Timer_timeout():
	self.cooldown_active = false
