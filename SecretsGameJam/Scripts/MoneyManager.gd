extends Node


export var money = 20
var treasures = []
export var m_treasure = 5
export var m_artifacts = 2
var artifacts = []
export var gold_pc = 0
export var rate = 0
export var t_rate = 0
export var treasure_price_mod = 0
export var artifact_price_mod = 0
export var a_rate = 0
var _timer = null
var boost_timer = null
var ruins = null
var rng = RandomNumberGenerator.new()
export var time_multiplier = 1
var rate_modifier = 1
var bosted_items = []
signal new_money(money,treasures,m_treasure,artifacts,m_artifacts)
signal new_level()
signal more_treasure(treasure)
signal more_artifacts(artifacts)
signal sell_treasure(id)
var go = true
export onready var loading = get_node("/root/Game/Loading")
var montized = false
var last_logged_time = 0
var current_arts = {
	"0":0,
	"1":0,
	"2":0,
	"3":0,
	"4":0
}





func _ready():
	load_data()
	GameState.connect("reset",self,"_reset")
	GameState.connect("game_on",self,"playing")
	rng.randomize()
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(time_multiplier)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
	emit_signal("new_money",int(money),treasures.size(),m_treasure,artifacts.size(),m_artifacts)

func _physics_process(delta):
	if WebMonetization.is_paying() and (montized == false or m_treasure == 5):
		print("Upgrading Slots")
		m_treasure += 3
		m_artifacts += 1
		treasure_price_mod += 10000
		artifact_price_mod += 15000
		emit_signal("more_treasure",treasures)
		emit_signal("more_artifacts",artifacts)
		emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
		montized = true
		save_data()
	elif not WebMonetization.is_paying() and (montized == false or m_treasure != 5):
		print("DownGrading Slots")
		m_treasure -= 3
		m_artifacts -= 1
		emit_signal("more_treasure",treasures)
		emit_signal("more_artifacts",artifacts)
		emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
		montized = false
		save_data()


func playing():
	if  last_logged_time > 0:
		var current_time = OS.get_unix_time()
		var difference = current_time - last_logged_time
		print(difference)
		loading.visible = true
		time_warp(difference)
		loading.visible = false
	emit_signal("more_treasure",treasures)
	emit_signal("more_artifacts",artifacts)
	
func _reset(stat,type):
	money = 20
	current_arts[str(type)] += stat
	match type:
		1:
			upgrade_ruins_rate(1,current_arts[str(type)])
		2:
			update_time_multiplyer(stat)
			upgrade_ruins_rate(1,current_arts["1"])
		3:
			update_max_treasure(stat)
			upgrade_ruins_rate(1,current_arts["1"])
		4:
			update_max_artifact(stat)
			upgrade_ruins_rate(1,current_arts["1"])

func update_time_multiplyer(amount):
	time_multiplier -= amount
	if time_multiplier <=0:
		time_multiplier = .001
	_timer.set_wait_time(time_multiplier)
	return

func get_time_mult():
	return time_multiplier

func sub_time_mult(amount):
	time_multiplier -= amount
	return

func timed_boost(time,boost,type):
	boost_timer = Timer.new()
	add_child(boost_timer)
	boost_timer.set_wait_time(time)
	boost_timer.set_one_shot(false) # Make sure it loops
	match type:
		'a_rate':
			a_rate += boost
			bosted_items.append(0)
		't_rate':
			t_rate += boost
			bosted_items.append(1)
		'gpc':
			for ruin in get_tree().get_nodes_in_group("Ruins"):
				ruin.boost_mult += boost
			bosted_items.append(2)
		'timer':
			update_time_multiplyer(.15)
			bosted_items.append(3)
	boost_timer.start()
	yield(boost_timer, "timeout")
	match type:
		'a_rate':
			a_rate -= boost
			bosted_items.erase(0)
		't_rate':
			t_rate -= boost
			bosted_items.erase(1)
		'gpc':
			for ruin in get_tree().get_nodes_in_group("Ruins"):
				ruin.boost_mult -= boost
			bosted_items.erase(2)
		'timer':
			update_time_multiplyer(-.15)
			bosted_items.erase(3)
	boost_timer.queue_free()
	return


func _on_Timer_timeout():
	rate = 0
	a_rate = 0
	t_rate = 0
	if go:
		for ruin in get_tree().get_nodes_in_group("Ruins"):
			gold_pc = ruin.get_gold_pc()*rate_modifier
			rate += (ruin.rate*gold_pc)
			a_rate += ruin.a_rate 
			t_rate += ruin.t_rate
		money += int(rate)
		run_rng()
		save_data()
		emit_signal("new_money",int(money),treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	return
	
func get_current_money():
	return int(money)

func add_money(amount):
	money += int(amount)
	emit_signal("new_money",int(money),treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	save_data()
	
func remove_money(amount):
	money -=int(amount)
	emit_signal("new_money",int(money),treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	
func update_rate(amount):
	rate += amount
	return
	
func get_rate():
	return rate
	
func check_amount(amount):
	if amount <= int(money):
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
			ruin.upgrade_rate(_rate)
		else:
			continue

func run_rng():
	var a_rng = rng.randf_range(0, 100.0)
	var t_rng = rng.randf_range(0, 100.0)
	if artifacts.size() < m_artifacts:
		if a_rng <= a_rate:
			var artifact_id = rng.randi_range(1, 4)
			artifacts.append(artifact_id) 
			emit_signal("more_artifacts",artifacts)
			save_data()
	if treasures.size() < m_treasure:
		if t_rng <= t_rate:
			var treasure_id = rng.randi_range(1, 3)
			treasures.append(treasure_id) 
			emit_signal("more_treasure",treasures)
			save_data()
			
	return

func get_treasure_list():
	return treasures
	
func get_artifact_list():
	return artifacts

func current_arts_list():
	return current_arts

func set_ruins_gpc(id,multiplier):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.gold_pc(multiplier)
		else:
			continue
	return
			
			
func upgrade_ruins_level(id):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.upgrade()
			emit_signal("new_level")
		else:
			continue
	return
	
func get_ruins_mult(id):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			return ruin.gold_pc_mult
		else:
			continue
	return
func upgrade_ruins_rate(id,amount):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			ruin.upgrade_mult(amount)
		else:
			continue
	return

func get_ruins_gpc(id):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			return ruin.get_gold_pc()
		else:
			continue
	return 1
	
func upgrade_ruins_gpc(id,amount):
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		if ruin.id == id:
			print('Upgraded')
			ruin.upgrade_gpc(amount)
	return

func update_max_treasure(amount):
	m_treasure += amount
	emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	emit_signal("more_treasure",treasures)
	return
	
func update_max_artifact(amount):
	m_artifacts += amount
	emit_signal("new_money",money,treasures.size(),m_treasure,artifacts.size(),m_artifacts)
	emit_signal("more_artifacts",artifacts)
	return
	
func get_max_treasure():
	return m_treasure
	
func get_max_artifacts():
	return m_artifacts
	
func get_boosted_items():
	return bosted_items

func sell_item(id,base):
	var add_amount = base + treasure_price_mod
	add_money(add_amount)
	treasures.remove(id)
	emit_signal("more_treasure",treasures)


func sell_artifact(id,base):
	var add_amount = base + artifact_price_mod
	add_money(add_amount)
	artifacts.remove(id)
	emit_signal("more_artifacts",artifacts)
	
func get_treasure_price_mod():
	return treasure_price_mod

func sell_all_artifact():
	artifacts.clear()
	emit_signal("more_artifacts",artifacts)


func first_artifact():
	artifacts.append(1) 
	GameState.story_playing(1)
	emit_signal("more_artifacts",artifacts)
	
	
func save_data():
	var file = File.new()
	if file.open("user://MoneyManager.sav", File.WRITE ) != 0:
		print("Error opening file")
		return
	var data = {
	"moneys":money,
	"time_multiplier":time_multiplier,
	"rate_modifier":rate_modifier,
	"current_arts":current_arts,
	"artifacts":artifacts,
	"treasures":treasures,
	"time":OS.get_unix_time(),
	"montized":montized
	}
	file.store_line(to_json(data))
	file.close()
	
	
func load_data():
	var file = File.new()
	if not file.file_exists("user://MoneyManager.sav"):
		print("No file saved!")
		return
		  
	if file.open("user://MoneyManager.sav", File.READ) != 0:
		print("Error opening file")
		file.close()
		return
		
	var load_data = {}
	load_data = parse_json(file.get_line())
	money = load_data["moneys"]
	time_multiplier = load_data["time_multiplier"]
	rate_modifier = load_data["rate_modifier"]
	current_arts = load_data["current_arts"]
	artifacts = load_data["artifacts"]
	treasures = load_data["treasures"]
	last_logged_time = load_data["time"]
	montized = load_data["montized"]
	file.close()
	
func time_warp(time):
	print("money then-" + str(money))
	for ruin in get_tree().get_nodes_in_group("Ruins"):
		gold_pc = ruin.get_gold_pc()*rate_modifier
		rate += (ruin.rate*gold_pc)
		a_rate += ruin.a_rate 
		t_rate += ruin.t_rate
	print(rate)
	if rate > 0:
		for second in range(time):
			money += int(rate)
			run_rng()
	print("money now-" + str(money))
	print(time)
	save_data()
