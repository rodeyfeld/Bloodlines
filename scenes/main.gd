extends Node2D


var level0 = preload("res://scenes/levels/level0.tscn")
var start_screen = preload("res://scenes/ui/start_screen/start_screen.tscn")
var curr_scene = null

func _ready():
	curr_scene = start_screen.instance()
	add_child(curr_scene)
	curr_scene.start_button.connect("pressed", self, "start_button_pressed", [])
	
func start_button_pressed():
	curr_scene = level0.instance()
	get_tree().change_scene_to(level0)
	
