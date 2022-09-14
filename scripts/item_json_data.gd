extends Node

var inventory_data: Dictionary
var equipment_data: Dictionary

func _ready():
	inventory_data = load_data("res://scenes/items/json/inventory_data.json")
	equipment_data = load_data("res://scenes/items/json/equipment_data.json")
	
func load_data(file_path):
	var json_data
	var file_data = File.new()
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
	
