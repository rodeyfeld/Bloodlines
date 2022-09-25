extends Node2D

const slot_class = preload("res://scenes/ui/inventory/Slot.gd")


var item_scene = preload("res://scenes/ui/inventory/Item.tscn")
onready var inventory_container = $inventory_container/RightPanel/NinePatchRect/inventory_container
onready var equipment_container = $inventory_container/LeftPanel/equipment_container
onready var calculated_label = $inventory_container/LeftPanel/curr_equipped2/Label
var holding_item = null
var inventory_data = item_json_data.inventory_data


func _ready():
	var stored_inventory_items = item_json_data.inventory_data.Inventory_Items
	for inv_slot in equipment_container.get_children():
		inv_slot.equip_type = true
		inv_slot.refresh_style()
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
	for inv_slot in inventory_container.get_children():
#		slot_item.item_name = stored_inventory_item.
		if len(stored_inventory_items) > 0:
			var stored_inventory_item = stored_inventory_items.pop_front()
			var item = item_scene.instance()
			inv_slot.item = item
			inv_slot.item.item_name = stored_inventory_item['ItemName']
			inv_slot.item.icon_path = stored_inventory_item['IconPath']
			inv_slot.item.description = stored_inventory_item['Description']
			inv_slot.item.item_buffs = stored_inventory_item['ItemBuffs']
			inv_slot.item.load_texture()
			inv_slot.load_item()
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
		
		
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
					var temp_item = slot.item
					slot.pick_from_slot()
					temp_item.global_position = event.global_position
					slot.put_into_slot(holding_item)
					holding_item = temp_item
			elif slot.item:
				holding_item = slot.item
				slot.pick_from_slot()
				holding_item.global_position = get_global_mouse_position()
	

func _input(_event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()
	
func update_calculated():
	var base_dict = {
		'BonusHealth': 0,
		'BonusDamage': 0
	}
	for inv_slot in equipment_container.get_children():
		if inv_slot.item != null:
			base_dict.BonusHealth += inv_slot.item.item_buffs.BonusHealth
			base_dict.BonusDamage += inv_slot.item.item_buffs.BonusDamage
	
	calculated_label.text = str("Bonus Health: ", base_dict.BonusHealth, "\n", "Bonus Damage: ", base_dict.BonusDamage)
	

func _on_Panel5_equipment_updated():
	update_calculated()

func _on_Panel6_equipment_updated():
	update_calculated()

func _on_Panel7_equipment_updated():
	update_calculated()

func _on_Panel8_equipment_updated():
	update_calculated()

func _on_Panel9_equipment_updated():
	update_calculated()

func _on_Panel10_equipment_updated():
	update_calculated()
