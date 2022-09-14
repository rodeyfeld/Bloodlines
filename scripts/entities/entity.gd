extends KinematicBody2D
class_name Entity

var velocity : Vector2 = Vector2() 
var direction : Vector2 = Vector2()

var max_health: int = 100 
var current_health : int = 100 
var health_regen : int = 1
var armor : int = 0

var max_mana : int = 100 
var current_mana : int = 100 
var mana_regen : int = 1

var max_speed : float = 200 
var current_speed : float = 0 
var acceleration : float = 4

var agility : int = 1

var global_cooldown = 30 
var is_busy : bool = false 
var last_ability : int = 0

func regen_health():
	if (current_health < max_health):
		if ((health_regen + current_health) > max_health):
			current_health = max_health
		else: current_health += health_regen

func regen_mana():
	if (current_mana < max_mana):
		if ((mana_regen + current_mana) > max_mana):
			current_mana = max_mana 
		else: current_mana += mana_regen

func modify_mana(amount):
	var new_mana = current_mana + amount 
	if (new_mana < 0): current_mana = 0 
	if (new_mana > max_mana): current_mana = max_mana 
	else: current_mana += amount

func apply_damages(amount):
	if (armor > 0): amount = amount * ((100 - armor) * .01) 
	if (current_health > amount): current_health -= amount 
	else: print("death")

func _physics_process(_delta):
	last_ability += 1

func load_ability(element, _name):
	var scene = load("res://scenes/abilities/" + element + "/" + _name.to_lower() + "/" + _name + ".tscn")
	var scene_node = scene.instance()
	add_child(scene_node)
	return scene_node
