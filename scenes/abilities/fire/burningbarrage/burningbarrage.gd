extends Node

var firebolt = load("res://scenes/p_effects/bloodflame/fireball.tscn")

var distance = 200
var speed = 300
var cooldown = .5
var cooldown_active = false
var capacity = 3

onready var capacity_timer = $capacity_timer
onready var timer = $Timer

func execute(s, direction=null):
	if !cooldown_active:
		start_cooldown(cooldown)
		if !direction: direction = (s.get_global_mouse_position() - s.position).normalized()
		for angle in [0]:
			var radians = deg2rad(angle)
			var f = firebolt.instance()
			f.position.x = s.position.x + direction.x * 50
			f.position.y = s.position.y + direction.y * 50
			f.configure(s, direction, distance, speed)
			f.direction = direction.rotated(radians)
			add_child(f)
			var look_at = s.get_global_mouse_position()
			var _direction = (look_at  - s.position);
			var new_angle =  atan2(_direction.y, _direction.x)
			f.rotate(new_angle)
#			f.rotation.y += randi() % 10
			

func start_cooldown(duration):
	self.cooldown_active = true
	timer.start(duration)
	
func _on_Timer_timeout():
	self.cooldown_active = false
