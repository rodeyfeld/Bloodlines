extends KinematicBody2D

var explosion = preload("res://scenes/p_effects/bloodflame/meteor/explosion.tscn")

onready var collision_shape = $Hitbox/CollisionShape2D

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
#	move_and_slide(velocity)

func _physics_process(delta):
	position = position.move_toward(destination_pos, delta * velocity)
#	move_and_slide(velocity * MAX_SPEED)
	if position == destination_pos:
		collision_shape.disabled = false
		yield(get_tree(), "idle_frame")	
		var e = explosion.instance()
		e.position.x = self.position.x
		e.position.y = self.position.y
		get_node("/root").add_child(e)
		queue_free()
#
