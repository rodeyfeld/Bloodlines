extends Node2D

const slot_class = preload("res://scenes/inventory/Slot.gd")
var item_scene = preload("res://scenes/inventory/Item.tscn")
onready var inventory_container = $inventory_container/RightPanel/NinePatchRect/inventory_container
var holding_item = null
var inventory_data = item_json_data.inventory_data


func _ready():
	var stored_inventory_items = item_json_data.inventory_data.Inventory_Items
	for inv_slot in inventory_container.get_children():
		var item = item_scene.instance()
#		slot_item.item_name = stored_inventory_item.
		if len(stored_inventory_items) > 0:
			var stored_inventory_item = stored_inventory_items.pop_front()
			
			print(stored_inventory_item)
			item.item_name = stored_inventory_item['ItemName']
			print(item.item_name)
			inv_slot.item = item
			inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
#		print(inv_slot.item)
		
		
func slot_gui_input(event: InputEvent, slot: slot_class):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			# Currently holding item
			if holding_item != null:
				# Empty slot
				if !slot.item:
					slot.put_into_slot(holding_item)
					holding_item = null
				# Slot alreay contains item
				else:
					# New item, swap
					if holding_item.item_name != slot.item.item_name:
						var temp_item = slot.item
						slot.pick_from_slot()
						temp_item.global_position = event.global_position
						slot.put_into_slot(holding_item)
						holding_item = temp_item
					# Same item, try merge
#					else:
#						var stack_size = int(inventory_data[slot.item.item_name]["StackSize"])
#						slot.item.add_item_quantity(holding_item.item_quantity)
#						holding_item.queue_free()
#						holding_item = null
			elif slot.item:
				holding_item = slot.item
				slot.pick_from_slot()
				holding_item.global_position = get_global_mouse_position()

func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
