extends Entity

var death_smoke = preload("res://scenes/effects/Deathsmoke.tscn")
var floating_text = preload("res://scenes/effects/dmg_text/dmg.tscn")
var knockback = Vector2.ZERO
var level_navigation: Navigation2D = null
var target = null
var path:Array = []
var player_located:bool = false
var attack_vector
export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK
} 
var state = CHASE

onready var entity_stats = $entity_stats
onready var status_tags = $status_tags
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var aoe_raycast = $Hurtbox/RayCast2D
onready var enemy_detection_zone = $enemy_detection_zone
onready var enemy_attack_zone = $enemy_attack_zone
onready var idle_timer = $idle_timer
onready var raycast_to_trail = $raycast_to_trail
onready var wander_timer = $wander_timer
onready var animation_tree = $animation_tree
onready var soft_body_collision = $soft_body_collision
onready var hp_bar = $hp_bar
onready var hitbox_shape = 	$hitbox_pivot/Hitbox/CollisionShape2D
onready var animation_state = animation_tree.get("parameters/playback")
var raycast_adjustments = [Vector2(0, -10), Vector2(0, 10), Vector2(10, 0), Vector2(-10, 0)]

func _ready():
	animation_tree.active = true
	hp_bar.max_value = entity_stats.max_health
	hp_bar.value = entity_stats.max_health
#	chase()

func _physics_process(delta):
	
	animation_tree.set("parameters/Run/blend_position", velocity.normalized())
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_state.travel("Idle")
			look_for_player()
			if idle_timer.time_left <= 0:
				state = WANDER
		CHASE:
			wander_timer.stop()
			animation_state.travel("Run")
			chase_target()
			if !target:
				state = IDLE
				idle_timer.start()
			else:
				idle_timer.stop()
		WANDER:
			animation_state.travel("Run")
			look_for_player()
			if wander_timer.time_left <= 0:
				wander()
		ATTACK:
			animation_tree.set("parameters/Attack/blend_position", attack_vector)
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_state.travel("Attack")
				
	if soft_body_collision.is_colliding():
		velocity += soft_body_collision.get_push_vector() * delta * 100
	
	var _val = move_and_slide(velocity * MAX_SPEED)
		

func look_for_player():
	if enemy_detection_zone.is_player_visible():
		state = CHASE

func chase_target():
	if enemy_detection_zone.player:
		target = enemy_detection_zone.player
		var cast_to_player = true
		# Try to find player
		for raycast_adjustment in raycast_adjustments:
			raycast_to_trail.cast_to = (target.position + raycast_adjustment) - self.position
			raycast_to_trail.force_raycast_update()
			if raycast_to_trail.is_colliding():
				cast_to_player = false
				break
		# We can see player, set direction to move toward it
		if cast_to_player:
			self.velocity = (target.position - self.position).normalized()
			return
		
		# Otherwise we check each trail for a direction
		for trail in target.target_trail:
			var cast_to_trail = true
			for raycast_adjustment in raycast_adjustments:
				raycast_to_trail.cast_to = (trail.position + raycast_adjustment) - self.position
				raycast_to_trail.force_raycast_update()
				if raycast_to_trail.is_colliding():
					cast_to_trail = false
					break
			if cast_to_trail:
				self.velocity = (trail.position - self.position).normalized()
				break
	else:
		target = null

func wander():
	randomize()
	self.velocity = Vector2(rand_range(-0.2, 0.2), rand_range(-0.2, 0.2))
	wander_timer.start()
		
# For AOE ability checks	
func check_raycast(area):
	if area.area_raycast_check:
		aoe_raycast.cast_to = aoe_raycast.to_local(area.global_position)
		aoe_raycast.enabled = true
		aoe_raycast.force_raycast_update()
		if aoe_raycast.is_colliding():
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
		entity_stats.health -= area.damage
		hp_bar.value = entity_stats.health
		

func _on_entity_stats_no_health():
	var ds = death_smoke.instance()
	ds.position.x = self.position.x
	ds.position.y = self.position.y
	get_node("/root").add_child(ds)
	queue_free()


func _on_idle_timer_timeout():
	state = IDLE

func _on_enemy_attack_zone_area_entered(_area):
	attack_vector = velocity.normalized()
	state = ATTACK

func _on_enemy_attack_zone_area_exited(_area):
	hitbox_shape.set_deferred("disabled", true)
	state = CHASE
