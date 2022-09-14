extends KinematicBody2D

var parent = null

func configure(s = null):
	parent = s
	position.x = parent.position.x
	position.y = parent.position.y

func _physics_process(_delta):
	position.x = parent.position.x
	position.y = parent.position.y
