extends Entity

var death_smoke = preload("res://scenes/effects/Deathsmoke.tscn")
var floating_text = preload("res://scenes/effects/dmg_text/dmg.tscn")
var knockback = Vector2.ZERO
var level_navigation: Navigation2D = null
var target = null
var path:Array = []
var player_located:bool = false

export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
} 
var state = CHASE

onready var stats = $Stats
#onready var status_tags = $StatusTags
onready var hurtbox = $Hurtbox
onready var sprite = $AnimatedSprite
onready var healthbar = $AnimatedSprite/Healthbar
onready var aoe_raycast = $Hurtbox/RayCast2D
onready var enemy_detection_zone = $enemy_detection_zone
onready var idle_timer = $idle_timer
onready var raycast_to_trail = $raycast_to_trail
onready var chase_timer = $chase_timer
onready var animation_tree = $animation_tree
onready var animation_state = animation_tree.get("parameters/playback")
var raycast_adjustments = [Vector2(0, -10), Vector2(0, 10), Vector2(10, 0), Vector2(-10, 0)]

func _ready():
	healthbar.min_value = 0
	healthbar.max_value = stats.max_health
	animation_tree.active = true
#	chase()

func _physics_process(delta):
	
	animation_tree.set("parameters/Run/blend_position", velocity.normalized())
	print(state, velocity)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			animation_state.travel("Idle")
			look_for_player()
		CHASE:
			animation_state.travel("Run")
			chase_target()
			if !target:
				state = IDLE
				

		
	var _val = move_and_slide(velocity * MAX_SPEED)


func look_for_player():
	if enemy_detection_zone.is_player_visible():
		state = CHASE

func chase_target():
	if enemy_detection_zone.player:
		target = enemy_detection_zone.player
		var cast_to_player = true
		for raycast_adjustment in raycast_adjustments:
			raycast_to_trail.cast_to = (target.position + raycast_adjustment) - self.position
			raycast_to_trail.force_raycast_update()
			if raycast_to_trail.is_colliding():
				cast_to_player = false
				break
	#		if !raycast_to_trail.is_colliding():
	#			print("chasing player")
	#			self.velocity = raycast_to_trail.cast_to.normalized()
		if cast_to_player:
			self.velocity = (target.position - self.position).normalized()
			return
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
	print(velocity)
	
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
		stats.health -= area.damage
		healthbar.value = stats.health

func _on_Stats_no_health():
	sprite.play("death")
	queue_free()
	var ds = death_smoke.instance()
	ds.position.x = self.position.x
	ds.position.y = self.position.y
	get_node("/root").add_child(ds)
