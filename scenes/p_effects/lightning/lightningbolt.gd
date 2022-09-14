extends Node2D


var spark_emitter = preload("res://scenes/p_effects/lightning/spark.tscn")

var chain_detection_zone = preload("res://scenes/overlap/ChainDetectionZone.tscn")

onready var raycast = $Raycast2D
onready var line2d = $Line2D
onready var hitbox = $Hitbox
onready var animationPlayer = $AnimationPlayer

var orig
var point_segments = 8
var cdz

func configure(o_pos, pos):
	o_pos += Vector2(-20, 0).rotated(o_pos.angle_to_point(pos))
	raycast.position = raycast.to_local(o_pos)
	raycast.cast_to = raycast.to_local(pos) * 200
	raycast.enabled = true
	raycast.force_raycast_update()
	var coll_point = raycast.get_collision_point()
	line2d.points[0] = o_pos
	line2d.points[1] = coll_point
	cdz = chain_detection_zone.instance()
	if raycast.get_collider().get_collision_mask_bit(5):
		hitbox.position = raycast.get_collider().hurtbox.global_position
		cdz.unit_stunned = raycast.get_collider()
	add_child(cdz)
	cdz.global_position = coll_point
#	print(cdz.position)
	animationPlayer.play("fade")
	return raycast


func _on_Timer_timeout():
	queue_free()


#
#func drawToPoint():
#	print(orig.position, position2d.position)
#	var distance = orig.position.distance_to(position2d.position)
#	var points = PoolVector2Array()
#	var point_count = floor(distance / point_segments)
#	points.append(Vector2(orig.position.x, orig.position.y))
#	for i in range(1, point_count-1):
#		var point_vector = Vector2(i * point_segments, randi() % 50)
#		points.append(point_vector)
#	points.append(Vector2(position2d.position.x, position2d.position.y))
#	line2d.points = points
#	print(points)
#	for point in points:
#		var s = spark_emitter.instance()
#		s.position.x = point.x
#		s.position.y = point.y
#		s.emitting = true
#		get_node("/root").call_deferred("add_child", s)


