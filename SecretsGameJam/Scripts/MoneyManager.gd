extends Node


export var money = 50
export var treasure = 0
export var artifacts = 0
export var rate = 0
var _timer = null
var ruins = null

signal new_money(money,treasure,artifacts)

func _ready():
	emit_signal("new_money",money,treasure,artifacts)
	_timer = Timer.new()
	add_child(_timer)
	
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(.1)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _on_Timer_timeout():
	rate = 0
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		rate += ruin.rate*ruin.gold_pc
	money += rate/10
	emit_signal("new_money",money,treasure,artifacts)

func get_current_money():
	return money

func add_money(amount):
	money += amount
	emit_signal("new_money",money,treasure,artifacts)
	
func remove_money(amount):
	money -= amount
	emit_signal("new_money",money,treasure,artifacts)
	
func update_rate(amount):
	rate += amount

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
