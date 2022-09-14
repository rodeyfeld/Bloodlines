extends Node

var plume = load("res://scenes/abilities/fire/base/plume/plume.tscn")

var distance = 120
var speed = 200
var cooldown = 1
var cooldown_active = false
var radius = 20
var p

onready var timer = $Timer

func execute(s, direction=null):
	if !cooldown_active:
		start_cooldown(cooldown)
		if !direction: direction = (s.get_global_mouse_position() - s.position).normalized()
		
		p = plume.instance()
		p.position.x = s.position.x
		p.position.y = s.position.y
		p.configure(s)
		get_node("/root").add_child(p)
		var mouse_pos = s.get_global_mouse_position()
		p = plume.instance()
		p.position.x = mouse_pos.x
		p.position.y = mouse_pos.y
		p.configure(s, true)
		get_node("/root").add_child(p)

func start_cooldown(duration):
	self.cooldown_active = true
	timer.start(duration)
	
func _on_Timer_timeout():
	self.cooldown_active = false
