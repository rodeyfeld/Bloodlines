extends Entity

var death_smoke = preload("res://scenes/effects/Deathsmoke.tscn")
var floating_text = preload("res://scenes/effects/dmg_text/dmg.tscn")
var knockback = Vector2.ZERO


export var ACCELERATION = 300
export var MAX_SPEED = 20
export var FRICTION = 200


onready var stats = $Stats
onready var status_tags = $StatusTags
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var healthbar = $AnimatedSprite/Healthbar
onready var raycast = $Hurtbox/RayCast2D
onready var enemy_detection_zone = $EnemyDetectionZone
onready var enemy_detection_not_detected_timer = $EnemyDetectionZone/DetectedTimer
onready var enemy_detection_wander_timer = $EnemyDetectionZone/WanderTimer


enum {
	IDLE,
	WANDER,
	CHASE
}
var state = CHASE

func _ready():
	healthbar.min_value = 0
	healthbar.max_value = stats.max_health


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,  FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			sprite.play("idle")
#			if enemy_detection_wander_timer.get_time_left() == 0:
#				enemy_detection_wander_timer.start()
			seek_player()
#		WANDER:
#			wander(delta)
		CHASE:
			var player = enemy_detection_zone.player
			if player != null:
				sprite.play("run")
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				enemy_detection_not_detected_timer.start()
				state = IDLE
				
			sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func seek_player():
	if enemy_detection_zone.is_player_visible():
		state = CHASE

func wander(delta):
	print("wandering")
	sprite.play("run")
	var direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
	state = IDLE
	
	
func check_raycast(area):
	if area.area_raycast_check:
		raycast.cast_to = raycast.to_local(area.global_position)
		raycast.enabled = true
		raycast.force_raycast_update()
		if raycast.is_colliding():
			return true
	return false

func _on_Hurtbox_area_entered(area):
	var disable_dmg = check_raycast(area)
	if not disable_dmg:
		var text = floating_text.instance()
		text.amount = area.damage
		get_node("/root").add_child(text)
		text.position.x = self.position.x - (randi() % 50)
		text.position.y = self.position.y - 40 - (randi() % 50)
		stats.health -= area.damage
		healthbar.value = stats.health

func _on_Stats_no_health():
	sprite.play("death")
	queue_free()
	var ds = death_smoke.instance()
	ds.position.x = self.position.x
	ds.position.y = self.position.y
	get_node("/root").add_child(ds)

func _on_DetectedTimer_timeout():
#	state = WANDER
	pass
