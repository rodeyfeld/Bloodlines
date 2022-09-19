extends Area2D

var player = null

onready var detected_timer = $detected_timer

func is_player_visible():
	return player != null

func _on_enemy_detection_zone_body_entered(body):
	player = body
	detected_timer.start(8)
	

func _on_detected_timer_timeout():
	player = null
