extends KinematicBody2D

var velocity = Vector2()
var firebolt_extinguish = load("res://scenes/abilities/fire/base/firebolt/firebolt_extinguish.tscn")

var direction = null
var distance = null
var speed = null
var parent = null
var moved = 0


func configure(s = null, n_direction = null, n_distance = null, n_speed = null):
	parent = s
	direction = n_direction
	distance = n_distance
	speed = n_speed

func _physics_process(_delta):
	if moved < distance: move()
	if moved >= distance:
		trigger_finish()
		
func move():
	moved += 1
	velocity = Vector2()
	velocity.x = direction.x
	velocity.y = direction.y
	
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * speed)

func _on_Hitbox_area_entered(_area):
	trigger_finish()


func trigger_finish():
	var f = firebolt_extinguish.instance()
	f.position.x = self.position.x
	f.position.y = self.position.y
	get_node("/root").add_child(f)
	self.queue_free()
	
