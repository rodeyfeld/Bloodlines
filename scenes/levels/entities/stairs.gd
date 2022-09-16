extends Area2D
#
#var stairs_forward = "res://assets/tilemaps/catacombs/stairs_up.png"
#var stairs_backward= "res://assets/tilemaps/catacombs/stairs_down.png"

var to_scene = null
onready var timer: Timer = $Timer

func _ready():
	self.monitoring = true
	self.monitorable = true

func _on_Area2D_body_entered(body):
	set_deferred("monitoring", false)
	timer.start()
	
func _on_Timer_timeout():
	self.monitoring = true
