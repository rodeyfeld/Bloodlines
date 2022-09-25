extends Node2D

onready var tx = $TextureRect

var item_name
var item_quantity
var item_category
var base_buffs
var elemental_buffs
var icon_path
var description
var inventory_data = item_json_data.inventory_data

	
func load_texture():
	$TextureRect.texture = load(icon_path)

func configure_stacks():
	if item_name:
		var stack_size = int(inventory_data[item_name]["StackSize"])
		item_quantity = randi() % stack_size + 1
		if stack_size == 1:
			$Label.visible = false
		else:
			$Label.text = str(item_quantity)


func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = str(item_quantity)

func decrease_item_quantity(amount_to_add):
	item_quantity -= amount_to_add
	$Label.text = str(item_quantity)
