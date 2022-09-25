extends Node

const elemental_stats_scene= preload("res://scenes/attributes/elemental_stats.gd")
##########################################
### Stats related to the player itself ###
##########################################
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

onready var health = max_health setget set_health
onready var mana = max_mana
onready var armor = max_armor

var elemental_stats 

signal no_health
signal health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	elemental_stats = elemental_stats_scene.new()
	
	

