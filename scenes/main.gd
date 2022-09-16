extends Node


var level_0 = preload("res://scenes/levels/level_0.tscn")
var level_1 = preload("res://scenes/levels/level_1.tscn")
#var start_screen = preload("res://scenes/ui/start_screen/start_screen.tscn")
var level_templates = [level_0, level_1]
var existing_levels = []
onready var curr_level = $level0

func _ready():
	existing_levels.append(curr_level)
	curr_level.stairs_forward.area2d.connect("body_entered", self, "handle_level_forward")
#
#func start_button_pressed():
#	remove_child(curr_scene)
#	var new_scene = instance_new_level()
#	add_child(new_scene)
#	curr_scene = new_scene
#	curr_scene.stairs_forward.area2d.connect("body_entered", self, "transition_level", [])
#
func handle_level_backward(area):
	pass

func handle_level_forward(area):
#	curr_level.visible=false
	var next_level = curr_level.stairs_forward.to_scene
	if next_level == null:
		next_level = instance_new_level()
		
	call_deferred("remove_child", curr_level)
	yield(get_tree(), "idle_frame")
#	get_tree().change_scene_to(level_0)
	call_deferred("add_child", next_level)
	yield(get_tree(), "idle_frame")
	next_level.stairs_backward.area2d.connect("body_entered", self, "handle_level_backward")
	next_level.stairs_forward.area2d.connect("body_entered", self, "handle_level_forward")
#	curr_level.stairs_forward.area2d.connect("body_entered", self, "handle_level_transition")
#	curr_level.queue_free()
	curr_level = next_level
#
	
func instance_new_level():
	return level_templates[randi() % level_templates.size()].instance()
	
	
