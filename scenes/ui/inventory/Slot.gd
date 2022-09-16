extends Panel


var empty_tex = preload("res://assets/ui/slot2.png")
var default_tex = preload("res://assets/ui/slot1.png")
var equipment_tex = preload("res://assets/ui/frame21.png")

#var item_scene = preload("res://scenes/inventory/Item.tscn")

var empty_style: StyleBoxTexture = null
var default_style: StyleBoxTexture = null
var equipment_style: StyleBoxTexture = null

var item = null
var equip_type = null

signal equipment_updated

func _ready():
	empty_style = StyleBoxTexture.new()
	empty_style.texture = empty_tex

	equipment_style = StyleBoxTexture.new()
	equipment_style.texture = equipment_tex
#
	default_style = StyleBoxTexture.new()
	default_style.texture = default_tex
#	item = item_scene.instance()
#	add_child(item)
	refresh_style()

func load_item():
	print(item)
	item.load_texture()
	add_child(item)
	refresh_style()

func refresh_style():
	if equip_type:
		set('custom_styles/panel', equipment_style)
		emit_signal("equipment_updated")
	elif item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)

	if item:
		var tooltip_str = str(item.item_name, "\n", item.item_buffs)
		set("hint_tooltip", tooltip_str)
	else:
		set("hint_tooltip", "")
		
func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("Inventory")
	inventory_node.add_child(item)
	item = null
	refresh_style()

func put_into_slot(new_item):
	item = new_item
	item.position = Vector2(0,0)
	var inventory_node = find_parent("Inventory")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()
