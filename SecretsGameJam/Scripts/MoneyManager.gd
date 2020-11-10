extends Node


export var money = 20
var treasures = []
export var m_treasure = 5
export var m_artifacts = 2
var artifacts = []
export var rate = 0
export var t_rate = 0
export var a_rate = 0
var _timer = null
var ruins = null
var rng = RandomNumberGenerator.new()
export var time_multiplier = 1

signal new_money(money,treasures,m_treasure,artifacts,m_artifacts)
signal new_level()
signal more_treasure(treasure)
signal more_artifacts(artifacts)

func _ready():
	emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	rng.randomize()
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(time_multiplier)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func get_time_mult():
	return time_multiplier

func sub_time_mult(amount):
	time_multiplier -= amount

func _on_Timer_timeout():
	rate = 0
	a_rate = 0
	t_rate = 0
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		rate += ruin.rate*ruin.gold_pc
		a_rate += ruin.a_rate
		t_rate += ruin.t_rate
	money += rate
	run_rng()
	emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)

func get_current_money():
	return money

func add_money(amount):
	money += amount
	emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	
func remove_money(amount):
	money -= amount
	emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	
func update_rate(amount):
	rate += amount

func get_rate():
	return rate
	
func check_amount(amount):
	if amount <= money:
		return true
	else:
		return false

func get_ruins_rate(id):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			return ruin.rate
		else:
			continue
	
func set_ruins_rate(id,_rate):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.rate += _rate
		else:
			continue

func run_rng():
	var a_rng = rng.randf_range(0, 100.0)
	var t_rng = rng.randf_range(0, 100.0)
	print("Artifact : "+str(a_rng))
	print("Treasure : "+str(t_rng))
	if artifacts.size() < m_artifacts:
		if a_rng <= a_rate:
			var artifact_id = rng.randi_range(1, 2)
			print('got artifact?')
			artifacts.append(artifact_id) 
			emit_signal("more_artifacts",artifacts)
	if treasures.size() < m_treasure:
		if t_rng <= t_rate:
			var treasure_id = rng.randi_range(1, 3)
			treasures.append(treasure_id) 
			emit_signal("more_treasure",treasures)


func get_treasure_list():
	return treasures
	
func get_artifact_list():
	return artifacts

func set_ruins_gpc(id,multiplier):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.gold_pc(multiplier)
		else:
			continue
			
			
			
func upgrade_ruins_level(id):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.upgrade()
			emit_signal("new_level")
		else:
			continue

func get_ruins_gpc(id):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			return ruin.gold_pc
		else:
			continue
			
func upgrade_ruins_gpc(id,amount):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.upgrade_gpc(amount)
			

func update_max_treasure(amount):
	m_treasure += amount
	emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	emit_signal("more_treasure",treasures)
	
func update_max_artifact(amount):
	m_artifacts += amount
	emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	emit_signal("more_artifacts",artifacts)
	
func get_max_treasure():
	return m_treasure
	
func get_max_artifacts():
	return m_artifacts
