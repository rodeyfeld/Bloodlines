extends Node


const elemental_stat = preload("res://scenes/attributes/elemental_stat.gd")
const elemental_type_enum = preload("res://scenes/attributes/elemental_enum.gd")


var elemental_stats_by_type:Dictionary

func _init():
	var elemental_type_enum_instance = elemental_type_enum.new()
	elemental_stats_by_type = {
		elemental_type_enum_instance.elemental_type.FIRE: elemental_stat.new()
	}
	

