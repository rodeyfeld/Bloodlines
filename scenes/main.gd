extends Node


var level_0 = preload("res://scenes/levels/level_0.tscn")
var level_1 = preload("res://scenes/levels/level_1.tscn")
var player_scene = preload("res://scenes/entities/player/player.tscn")
var transition_scene = preload("res://scenes/levels/transitions/level_transition.tscn")
#var start_screen = preload("res://scenes/ui/start_screen/start_screen.tscn")
var level_templates = [level_0, level_1]
var level_count = 0
var player
onready var curr_level = $level0


func _ready():
	player = player_scene.instance()
	curr_level.stairs_forward.connect("body_entered", self, "handle_level_forward")
	curr_level.add_child(player)
	player.global_position = curr_level.stairs_forward.player_spawn_position.global_position

#func start_button_pressed():
#	remove_child(curr_scene)
#	var new_scene = instance_new_level()
#	add_child(new_scene)
#	curr_scene = new_scene
#	curr_scene.stairs_forward.area2d.connect("body_entered", self, "transition_level", [])
#

func handle_level_backward(_area):
	var next_level = curr_level.stairs_backward.to_scene
	
	# Start transition animation
	var transition = transition_scene.instance()
	add_child(transition)
	transition.transition_out()
	yield(transition.animation_player, "animation_finished")
	curr_level.remove_child(player)
	
	call_deferred("remove_child", curr_level)
	yield(get_tree(), "idle_frame")
	call_deferred("add_child", next_level)
	yield(get_tree(), "idle_frame")
	curr_level = next_level
	curr_level.add_child(player)
	player.global_position = curr_level.stairs_forward.player_spawn_position.global_position
	transition.transition_in()
	yield(transition.animation_player, "animation_finished")
	transition.queue_free()
	print("Backward: ", curr_level.id)
	
func handle_level_forward(_area):
	# Doing this check twice because the item isn't added yet
	var is_new_level = false
	var next_level = curr_level.stairs_forward.to_scene
	if next_level == null:
		is_new_level = true
		next_level = instance_new_level()
		next_level.id = level_count
		level_count += 1
	# Start transition animation
	var transition = transition_scene.instance()
	add_child(transition)
	transition.transition_out()
	yield(transition.animation_player, "animation_finished")
	
	# Faded to black, start operations
	curr_level.remove_child(player)
#	yield(get_tree(), "idle_frame")	
	# Call for old scene to be removed
	call_deferred("remove_child", curr_level)
	yield(get_tree(), "idle_frame")	
	# Call for new scene to be added
	call_deferred("add_child", next_level)
	yield(get_tree(), "idle_frame")
	# Start transition back animation

	if is_new_level:
		next_level.stairs_backward.connect("body_entered", self, "handle_level_backward")
		next_level.stairs_forward.connect("body_entered", self, "handle_level_forward")
	next_level.stairs_backward.to_scene = curr_level
	curr_level.stairs_forward.to_scene = next_level
	curr_level = next_level
	curr_level.add_child(player)
	player.global_position = curr_level.stairs_backward.player_spawn_position.global_position
	transition.transition_in()
	yield(transition.animation_player, "animation_finished")
	transition.queue_free()
	print("Forward: ", curr_level.id)


func instance_new_level():
	return level_templates[randi() % level_templates.size()].instance()
	
	
