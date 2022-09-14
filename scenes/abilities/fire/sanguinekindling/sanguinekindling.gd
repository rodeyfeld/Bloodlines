extends Node

var aura = load("res://scenes/abilities/fire/base/aura/aura.tscn")
var ring = load("res://scenes/abilities/fire/base/ring/ring.tscn")
var splash_up = load("res://scenes/abilities/fire/base/blood/splash_up.tscn")

var cooldown = 1
var cooldown_active = false
var toggled = false

var _aura = null
var _ring = null
var _splash_up = null

onready var timer = $Timer

func execute(s):
	if !cooldown_active:
		if !toggled:
			start_cooldown(cooldown)
			_aura = aura.instance()
			_aura.configure(s)
			get_node("/root").add_child(_aura)
#			_ring = ring.instance()
#			_ring.configure(s)
#			get_node("/root").add_child(_ring)
			_splash_up = splash_up.instance()
			_splash_up.configure(s)
			get_node("/root").add_child(_splash_up)
			toggled = true
		else:
			_aura.queue_free()
#			_ring.queue_free()
			_splash_up.queue_free()
			toggled = false
		
func start_cooldown(duration):
	self.cooldown_active = true
	timer.start(duration)
	
func _on_Timer_timeout():
	self.cooldown_active = false
