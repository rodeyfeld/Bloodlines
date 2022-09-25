extends Node


const elemental_stat = preload("res://scenes/attributes/elemental_stat.gd")
const elemental_type_enum = preload("res://scenes/attributes/elemental_enum.gd")


var elemental_stats:Dictionary

func _ready():
	var elemental_type_enum_instance = elemental_type_enum.instance()
	elemental_stats = {
		elemental_type_enum_instance.FIRE: elemental_stat.instance()
	}
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
