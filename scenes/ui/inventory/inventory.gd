extends Node2D

const slot_class = preload("res://scenes/ui/inventory/Slot.gd")
const elemental_type_enum = preload("res://scenes/attributes/elemental_enum.gd")


var item_scene = preload("res://scenes/ui/inventory/Item.tscn")
onready var inventory_container = $inventory_container/RightPanel/NinePatchRect/inventory_container
onready var equipment_container = $inventory_container/LeftPanel/equipment_container
onready var calculated_label = $inventory_container/LeftPanel/curr_equipped2/Label
onready var holy_button = $inventory_container/LeftPanel/curr_equipped2/holy
var holding_item = null
var entity_stats = null
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
			inv_slot.item.base_buffs = stored_inventory_item['BaseBuffs']
			inv_slot.item.elemental_buffs = stored_inventory_item['ElementalBuffs']
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
	var elemental_type_instance = elemental_type_enum.new()
	if entity_stats:
		entity_stats.equipment_stats.set_to_zero()
		for inv_slot in equipment_container.get_children():
			if inv_slot.item != null:
	#			print(inv_slot.item.item_buffs.keys())
				entity_stats.equipment_stats.max_health += inv_slot.item.base_buffs['MaxHealth']
				entity_stats.equipment_stats.health_regen_percent +=  inv_slot.item.base_buffs['HealthRegenPercent']
				entity_stats.equipment_stats.health_regen_flat +=  inv_slot.item.base_buffs['HealthRegenFlat']
				# mana
				entity_stats.equipment_stats.max_mana +=  inv_slot.item.base_buffs['MaxMana']
				entity_stats.equipment_stats.mana_regen_percent +=  inv_slot.item.base_buffs['ManaRegenPercent']
				entity_stats.equipment_stats.mana_regen_flat +=  inv_slot.item.base_buffs['ManaRegenFlat']
				# armor
				entity_stats.equipment_stats.max_armor +=  inv_slot.item.base_buffs['MaxArmor']
				entity_stats.equipment_stats.armor_regen_percent +=  inv_slot.item.base_buffs['ArmorRegenPercent']
				entity_stats.equipment_stats.armor_regen_flat +=  inv_slot.item.base_buffs['ArmorRegenFlat']
				# speed
				entity_stats.equipment_stats.speed_percent +=  inv_slot.item.base_buffs['SpeedPercent']
				entity_stats.equipment_stats.speed_flat +=  inv_slot.item.base_buffs['SpeedFlat']
				for element in inv_slot.item.elemental_buffs.keys():
					entity_stats.equipment_stats.elemental_stats.elemental_stats_by_type[elemental_type_instance.elemental_type.get(element)].damage_flat += inv_slot.item.elemental_buffs[str(element)]["DamageFlat"]
					entity_stats.equipment_stats.elemental_stats.elemental_stats_by_type[elemental_type_instance.elemental_type.get(element)].damage_percent += inv_slot.item.elemental_buffs[str(element)]["DamagePercent"]
					entity_stats.equipment_stats.elemental_stats.elemental_stats_by_type[elemental_type_instance.elemental_type.get(element)].cooldown_flat += inv_slot.item.elemental_buffs[str(element)]["CooldownFlat"]
					entity_stats.equipment_stats.elemental_stats.elemental_stats_by_type[elemental_type_instance.elemental_type.get(element)].cooldown_percent += inv_slot.item.elemental_buffs[str(element)]["CooldownPercent"]
					entity_stats.equipment_stats.elemental_stats.elemental_stats_by_type[elemental_type_instance.elemental_type.get(element)].area_flat += inv_slot.item.elemental_buffs[str(element)]["AreaFlat"]
					entity_stats.equipment_stats.elemental_stats.elemental_stats_by_type[elemental_type_instance.elemental_type.get(element)].area_percent += inv_slot.item.elemental_buffs[str(element)]["AreaPercent"]
					entity_stats.equipment_stats.elemental_stats.elemental_stats_by_type[elemental_type_instance.elemental_type.get(element)].projectile_speed_flat += inv_slot.item.elemental_buffs[str(element)]["ProjectileSpeedFlat"]
					entity_stats.equipment_stats.elemental_stats.elemental_stats_by_type[elemental_type_instance.elemental_type.get(element)].projectile_speed_percent += inv_slot.item.elemental_buffs[str(element)]["ProjectileSpeedPercent"]
		entity_stats.update_stats()
	
#	calculated_label.text = str("Bonus Health: ", base_dict.BonusHealth, "\n", "Bonus Damage: ", base_dict.BonusDamage)
	

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


func _on_holy_toggled(button_pressed):
	print(button_pressed)
