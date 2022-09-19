extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var timer = $timer
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "remove_trail")

func remove_trail():
	player.target_trail.erase(self)
	queue_free()
