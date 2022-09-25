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

var elemental_stats

func _init():
	elemental_stats = elemental_stats_scene.new()
	
	

