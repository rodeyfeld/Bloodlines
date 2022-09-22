extends KinematicBody2D

onready var hitbox = $Hitbox

const MAX_SPEED = 300

var destination_pos
var start_pos
var velocity

func configure(s_pos, d_pos):
	start_pos = s_pos
	destination_pos = d_pos
	global_position = start_pos
#	velocity = velocity.move_toward(destination_pos - self.position).normalized()
	velocity = d_pos.distance_to(s_pos) / .5 
	print(velocity)
#	move_and_slide(velocity)

func _physics_process(delta):
	position = position.move_toward(destination_pos, delta * velocity)
#	move_and_slide(velocity * MAX_SPEED)
	if position == destination_pos:
		queue_free()
#
