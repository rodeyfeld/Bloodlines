extends Area2D

var player = null
var player_in_zone = false

onready var detected_timer = $detected_timer
onready var enemy_in_los = $RayCast2D

func is_player_visible():
	if player:
		enemy_in_los.cast_to = enemy_in_los.to_local(player.global_position)
		enemy_in_los.force_raycast_update()
		if !enemy_in_los.is_colliding():	
#			detected_timer.start(8)
			return true
	return false

func _on_enemy_detection_zone_body_entered(body):
	player_in_zone = true
	player = body

func _on_detected_timer_timeout():
	if !player_in_zone:
		print("player not in zone")
		player = null
	
func _on_enemy_detection_zone_body_exited(body):
	player_in_zone = false
	detected_timer.start(3)
