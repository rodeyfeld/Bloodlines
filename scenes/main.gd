extends Node


var level_0 = preload("res://scenes/levels/level_0.tscn")
var level_1 = preload("res://scenes/levels/level_1.tscn")
#var start_screen = preload("res://scenes/ui/start_screen/start_screen.tscn")
var level_templates = [level_0, level_1]
var existing_levels = []
var level_count = 0
onready var curr_level = $level0

func _ready():
	existing_levels.append(curr_level)
	curr_level.stairs_forward.connect("body_entered", self, "handle_level_forward")
#
#func start_button_pressed():
#	remove_child(curr_scene)
#	var new_scene = instance_new_level()
#	add_child(new_scene)
#	curr_scene = new_scene
#	curr_scene.stairs_forward.area2d.connect("body_entered", self, "transition_level", [])
#
func handle_level_backward(_area):
	var next_level = curr_level.stairs_backward.to_scene
	call_deferred("remove_child", curr_level)
	yield(get_tree(), "idle_frame")
	call_deferred("add_child", next_level)
	yield(get_tree(), "idle_frame")
	curr_level = next_level
	print(curr_level.id)
	
func handle_level_forward(_area):
	# Doing this check twice because the item isn't added yet
	var is_new_level = false
	var next_level = curr_level.stairs_forward.to_scene
	if next_level == null:
		is_new_level = true
		next_level = instance_new_level()
		next_level.id = level_count
		level_count += 1

	call_deferred("remove_child", curr_level)
	yield(get_tree(), "idle_frame")	
	call_deferred("add_child", next_level)
	yield(get_tree(), "idle_frame")
	if is_new_level:
		next_level.stairs_backward.connect("body_entered", self, "handle_level_backward")
		next_level.stairs_forward.connect("body_entered", self, "handle_level_forward")
	next_level.stairs_backward.to_scene = curr_level
	curr_level.stairs_forward.to_scene = next_level
	curr_level = next_level
	print(curr_level.id)

func instance_new_level():
	return level_templates[randi() % level_templates.size()].instance()
	
	
