extends Entity

export var FRICTION = 800
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var ACCELERATION = 500

enum {
	MOVE,
	IDLE,
	ATTACK
}


#var pyroblast = load_ability("fire", "pyroblast")
var meteor = load_ability("fire", "meteor")

var firenova = load_ability("fire", "firenova")
var sanguinekindling = load_ability("fire", "sanguinekindling")
var infernalgate = load_ability("fire", "infernalgate")

var chain_lighnting = load_ability("lightning", "chain_lightning")
var burningbarrage = load_ability("fire", "burningbarrage")

var floating_text = preload("res://scenes/effects/dmg_text/dmg.tscn")

var mouse_pos = Vector2.ZERO
var state = MOVE
var inventory = null
var target_trail = []

onready var inventory_scene = preload("res://scenes/ui/inventory/inventory.tscn")
onready var trail_scene = preload("res://scenes/entities/player/trail.tscn")
onready var trail_timer = $trail_timer
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var collision_shape2d = $CollisionShape2D
onready var stats = $stats
onready var hp_bar = $hud/meter_bars/hp_bar
onready var animationState = animationTree.get("parameters/playback")
onready var camera_offset_path = $camera_offset_area/camera_offset_path

func _ready():
	inventory = inventory_scene.instance()
	$hud.add_child(inventory)
	inventory.global_position = $hud/Position2D.global_position
	inventory.visible = false
	hp_bar.max_value = stats.max_health
	trail_timer.connect("timeout", self, "add_trail")

func _physics_process(delta):
	var aim_position = get_global_mouse_position()
	match state:
		MOVE:
			move_state(delta)
#		ATTACK:
#			attack_state()
	if Input.is_action_just_pressed("attack01"):
		randomize()
		camera_offset_path.unit_offset = rand_range(0, 1)
		meteor.execute(camera_offset_path.global_position, aim_position)
		last_ability = 0

	if Input.is_action_pressed("attack02"):
		firenova.execute(self)
		last_ability = 0

	if Input.is_action_just_pressed("attack03"):
#		sanguinekindling.execute(self)
		infernalgate.execute(self)
		last_ability = 0
	
	if Input.is_action_just_pressed("attack04"):
		chain_lighnting.execute(self)
		last_ability = 0
			
	if Input.is_action_pressed("attack05"):
		burningbarrage.execute(self)
		last_ability = 0
#
	if Input.is_action_just_pressed("inventory"):
		if !inventory.visible:
			inventory.visible = true
		else:
			inventory.visible = false
#		get_tree().change_scene("res://scenes/inventory/inventory.tscn")
		
func add_trail():
	var trail = trail_scene.instance()
	trail.player = self
	trail.position = self.position
#	get_node("/root").add_child(trail)
	get_parent().add_child(trail)
	target_trail.push_front(trail)
		

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	var look_at = self.get_global_mouse_position()
	var _direction = (look_at  - self.position);


	if input_vector != Vector2.ZERO:
#		roll_vector = input_vector
#		swordHitBox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
#		animationTree.set("parameters/Attack/blend_position", input_vector)
#		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()

func move():
	
	velocity = move_and_slide(velocity)



func _on_Hurtbox_area_entered(area):

	var text = floating_text.instance()
	print(area)
	text.amount = area.damage
	get_node("/root").add_child(text)
	text.position.x = self.position.x - (randi() % 50)
	text.position.y = self.position.y - 40 - (randi() % 50)
	stats.health -= area.damage
	hp_bar.value = stats.health
