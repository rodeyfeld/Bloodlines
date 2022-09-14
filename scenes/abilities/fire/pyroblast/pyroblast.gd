extends Node

var fireball = load("res://scenes/abilities/fire/base/fireball/fireball_large.tscn")

var distance = 120
var speed = 200
var cooldown = 1
var cooldown_active = false

onready var timer = $Timer

func execute(s, direction=null):
	if !cooldown_active:
		start_cooldown(cooldown)
		if !direction: direction = (s.get_global_mouse_position() - s.position).normalized()
		var look_at = s.get_global_mouse_position()
		
		var f = fireball.instance()
		f.position.x = s.position.x + direction.x * 50
		f.position.y = s.position.y + direction.y * 50
		f.configure(s, direction, distance, speed)
		get_node("/root").add_child(f)
		var _direction = (look_at  - s.position);
		var new_angle =  atan2(_direction.y, _direction.x)
		f.rotate(new_angle)

func start_cooldown(duration):
	self.cooldown_active = true
	timer.start(duration)
	
func _on_Timer_timeout():
	self.cooldown_active = false
