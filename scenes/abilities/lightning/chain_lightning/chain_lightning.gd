extends Node

var lightning_bolt = preload("res://scenes/p_effects/lightning/lightningbolt.tscn")

var distance = 120
var speed = 200
var cooldown = 1
var cooldown_active = false
var radius = 20
var new_target
var coll_point = null
var lightning_cdz_target
onready var timer = $Timer
onready var chain_timer = $chain


func execute(s, target=null):
	if !cooldown_active:
		start_cooldown(cooldown)
		if not target:
			target = s.get_global_mouse_position()
		trigger_shot(s.global_position, target)
		
func trigger_chain():
	print(lightning_cdz_target.get_overlapping_bodies())
	if lightning_cdz_target:
		if lightning_cdz_target.new_target and coll_point:
			print(lightning_cdz_target.new_target)
			trigger_shot(coll_point, lightning_cdz_target.new_target.global_position)

		
func trigger_shot(orig, pos):
		var bolt = lightning_bolt.instance()
		add_child(bolt)
		var hit = bolt.configure(orig, pos)
		if hit.get_collider().get_collision_mask_bit(5):
			hit.get_collider().status_tags.shocked = true
			lightning_cdz_target = bolt.cdz
			print(lightning_cdz_target)
			coll_point = hit.get_collider().global_position
			chain_timer.start()
	#
#func _physics_process(delta):
##	print(new_target)
#	if new_target:
#		print("new")
#		var bolt = lightning_bolt.instance()
#		add_child(bolt)
#		var hit = bolt.configure(coll_point, new_target.global_position)
#		if hit.get_collider().get_collision_mask_bit(5):
#			hit.get_collider().status_tags.shocked = true
#			new_target = bolt.cdz.new_target
#			coll_point = hit.get_collider()


func start_cooldown(duration):
	self.cooldown_active = true
	timer.start(duration)
	
func _on_Timer_timeout():
	self.cooldown_active = false


func _on_chain_timeout():
	trigger_chain()