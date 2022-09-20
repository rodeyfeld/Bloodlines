extends KinematicBody2D

var parent = null
var animationPlayer: AnimationPlayer
onready var hitbox = $Hitbox

func _ready():
	animationPlayer = $test
	hitbox.area_raycast_check = true

func configure(s = null):
	parent = s
	$test.play("New Anim (2)")
#	animationPlayer.play("New Anim (2)")
	position.x = parent.position.x
	position.y = parent.position.y
#
#func _physics_process(_delta):
#	position.x = parent.position.x
#	position.y = parent.position.y

func _on_Timer_timeout():
#	pass
	self.queue_free()
