extends Node


const stats_scene= preload("res://scenes/attributes/stats.gd")
const elemental_stats_scene= preload("res://scenes/attributes/elemental_stats.gd")
export(float) var max_health = 0.0
export(float) var health_regen_percent = 0.0
export(float) var health_regen_flat = 0.0
# mana
export(float) var max_mana = 0.0
export(float) var mana_regen_percent = 0.0
export(float) var mana_regen_flat = 0.0
# armor
export(float) var max_armor = 0.0
export(float) var armor_regen_percent = 0.0
export(float) var armor_regen_flat = 0.0
# speed
export(float) var speed_percent = 0.0
export(float) var speed_flat = 0.0

var equipment_stats
var base_stats
var elemental_stats
onready var health = max_health setget set_health
onready var mana = max_mana
onready var armor = max_armor


signal no_health
signal health_changed(value)


func _ready():
	equipment_stats = stats_scene.new()
	base_stats = stats_scene.new()
	elemental_stats = elemental_stats_scene.new()

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")


func update_stats():
	# health
	max_health = base_stats.max_health + equipment_stats.max_health
	health_regen_percent = base_stats.health_regen_percent + equipment_stats.health_regen_percent
	health_regen_flat = base_stats.health_regen_flat + equipment_stats.health_regen_flat
	# mana
	max_mana = base_stats.max_mana + equipment_stats.max_mana
	mana_regen_percent = base_stats.mana_regen_percent + equipment_stats.mana_regen_percent
	mana_regen_flat = base_stats.mana_regen_flat + equipment_stats.mana_regen_flat
	# armor
	max_armor = base_stats.max_armor + equipment_stats.max_armor
	armor_regen_percent = base_stats.armor_regen_percent + equipment_stats.armor_regen_percent
	armor_regen_flat = base_stats.armor_regen_flat + equipment_stats.armor_regen_flat
	# speed
	speed_percent = base_stats.speed_percent + equipment_stats.speed_percent
	speed_flat = base_stats.speed_flat + equipment_stats.speed_flat
	
	for elemental_stat in base_stats.elemental_stats.elemental_stats_by_type.keys():
		elemental_stats.elemental_stats_by_type[elemental_stat].damage_flat = base_stats.elemental_stats.elemental_stats_by_type[elemental_stat].damage_flat
		elemental_stats.elemental_stats_by_type[elemental_stat].damage_percent = base_stats.elemental_stats.elemental_stats_by_type[elemental_stat].damage_percent
		elemental_stats.elemental_stats_by_type[elemental_stat].cooldown_flat = base_stats.elemental_stats.elemental_stats_by_type[elemental_stat].cooldown_flat
		elemental_stats.elemental_stats_by_type[elemental_stat].cooldown_percent = base_stats.elemental_stats.elemental_stats_by_type[elemental_stat].cooldown_percent
		elemental_stats.elemental_stats_by_type[elemental_stat].area_flat = base_stats.elemental_stats.elemental_stats_by_type[elemental_stat].area_flat
		elemental_stats.elemental_stats_by_type[elemental_stat].area_percent = base_stats.elemental_stats.elemental_stats_by_type[elemental_stat].area_percent
		elemental_stats.elemental_stats_by_type[elemental_stat].projectile_speed_flat = base_stats.elemental_stats.elemental_stats_by_type[elemental_stat].projectile_speed_flat
		elemental_stats.elemental_stats_by_type[elemental_stat].projectile_speed_percent = base_stats.elemental_stats.elemental_stats_by_type[elemental_stat].projectile_speed_percent

	for elemental_stat in equipment_stats.elemental_stats.elemental_stats_by_type.keys():
		elemental_stats.elemental_stats_by_type[elemental_stat].damage_flat += equipment_stats.elemental_stats.elemental_stats_by_type[elemental_stat].damage_flat
		elemental_stats.elemental_stats_by_type[elemental_stat].damage_percent += equipment_stats.elemental_stats.elemental_stats_by_type[elemental_stat].damage_percent
		elemental_stats.elemental_stats_by_type[elemental_stat].cooldown_flat += equipment_stats.elemental_stats.elemental_stats_by_type[elemental_stat].cooldown_flat
		elemental_stats.elemental_stats_by_type[elemental_stat].cooldown_percent += equipment_stats.elemental_stats.elemental_stats_by_type[elemental_stat].cooldown_percent
		elemental_stats.elemental_stats_by_type[elemental_stat].area_flat += equipment_stats.elemental_stats.elemental_stats_by_type[elemental_stat].area_flat
		elemental_stats.elemental_stats_by_type[elemental_stat].area_percent += equipment_stats.elemental_stats.elemental_stats_by_type[elemental_stat].area_percent
		elemental_stats.elemental_stats_by_type[elemental_stat].projectile_speed_flat += equipment_stats.elemental_stats.elemental_stats_by_type[elemental_stat].projectile_speed_flat
		elemental_stats.elemental_stats_by_type[elemental_stat].projectile_speed_percent += equipment_stats.elemental_stats.elemental_stats_by_type[elemental_stat].projectile_speed_percent
		
		
