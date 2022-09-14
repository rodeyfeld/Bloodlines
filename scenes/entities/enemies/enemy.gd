extends Entity

var knockback = Vector2.ZERO
var death_smoke = preload("res://scenes/effects/Deathsmoke.tscn")
var floating_text = preload("res://scenes/effects/dmg_text/dmg.tscn")
var take_damage = false

onready var stats = $Stats
onready var hurtbox = $Hurtbox
onready var healthbar = $AnimatedSprite/Healthbar
onready var raycast = $Hurtbox/RayCast2D

func _ready():
	healthbar.min_value = 0
	healthbar.max_value = stats.max_health

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
	if area.area_raycast_check:
		raycast.cast_to = raycast.to_local(area.global_position)
		raycast.enabled = true
		raycast.force_raycast_update()
		if raycast.is_colliding():
			disable_dmg = true
	if not disable_dmg:
		var text = floating_text.instance()
		text.amount = area.damage
		get_node("/root").add_child(text)
		text.position.x = self.position.x - (randi() % 50)
		text.position.y = self.position.y - 40 - (randi() % 50)
		stats.health -= area.damage
		healthbar.value = stats.health

func _on_Stats_no_health():
	queue_free()
	var ds = death_smoke.instance()
	ds.position.x = self.position.x
	ds.position.y = self.position.y
	get_node("/root").add_child(ds)
