extends Node

var shocked = false setget set_shocked



onready var timer = $Timer

func set_shocked(value):
	shocked = value
	if shocked:
		timer.start()

func _on_Timer_timeout():
	shocked = false

