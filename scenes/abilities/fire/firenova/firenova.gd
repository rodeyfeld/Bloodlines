extends Node

var firenova = load("res://scenes/p_effects/bloodflame/nova.tscn")

var cooldown = 1
var cooldown_active = false


onready var timer = $Timer

func execute(s):
	if !cooldown_active:
		start_cooldown(cooldown)
		var f = firenova.instance()
		f.configure(s)
		get_node("/root").add_child(f)
		
func start_cooldown(duration):
	self.cooldown_active = true
	timer.start(duration)
	
func _on_Timer_timeout():
	self.cooldown_active = false
