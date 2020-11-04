extends Node


export var money = 50
export var treasure = 0
export var artifacts = 0
export var rate = 0
export var speed = 4
var loop_timer = null
var single_timer
var ruins = null
signal start_trip()
signal new_money(money,treasure,artifacts)

func _ready():
	emit_signal("new_money",money,treasure,artifacts)

func get_current_money():
	return money

func get_speed():
	return speed

func add_money(amount):
	money += amount
	emit_signal("new_money",money,treasure,artifacts)
	
func remove_money(amount):
	money -= amount
	emit_signal("new_money",money,treasure,artifacts)
	
func update_rate(amount):
	rate += amount

func finish_trip(amount):
	money += amount
	emit_signal("new_money",money,treasure,artifacts)
	
func check_amount(amount):
	if amount <= money:
		return true
	else:
		return false

func set_ruins_rate(id,_rate):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.rate += _rate
		else:
			continue

func set_ruins_gpc(id,gpc):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.gold_pc += gpc
		else:
			continue
			
			
			
func upgrade_ruins_level(id):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.level += 1
		else:
			continue

func get_ruins_gpc(id):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			return ruin.gold_pc
		else:
			continue
