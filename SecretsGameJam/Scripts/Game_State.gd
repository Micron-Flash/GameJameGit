extends Node

signal story(chapter)
signal game_on()
signal stop()
signal reset(stat,type)
export var state = 0
export var starting_state = 0
export var starting_chapter = 0
onready var camera = get_node("/root/Game/Camera2D")
onready var ruin = get_node("/root/Game/Ruins1")
var ruins = preload("res://scenes/Ruins1.tscn")
onready var tree = get_node("/root/Game/Trees")
onready var game = get_node("/root/Game")
var restarts = 0

func _ready():
	add_to_group("Persistanst")
	load_data()
	camera.position = Vector2(0,-400)
	if state != 0:
		play()
	camera.position = Vector2(0,-400)


func story_playing(chapter):
	print('sending signal')
	state = 0
	emit_signal("story",chapter)
	save_data()
	

func story_ended():
	state = 1
	emit_signal("game_on")
	save_data()
	
	
func play():
	state = 1
	emit_signal("game_on")
	save_data()
	

func stop():
	state = 2
	emit_signal("stop")
	
	save_data()
	
func get_state():
	return state

func start_game():
	camera.position = Vector2(0,0)

func reset(stat,type):
	restarts += 1
	ruin.queue_free() 
	reset_saves()
	var new_ruin = ruins.instance()
	new_ruin.position = Vector2(112.376,180.386)
	ruin = new_ruin
	game.add_child_below_node(tree,new_ruin,true)
	save_data()
	camera.position = Vector2(0,0)
	emit_signal("reset",stat,type)

func save_data():
	var file = File.new()
	if file.open("user://GameState.sav", File.WRITE ) != 0:
		print("Error opening file")
		return
	var data = {
	"state":state,
	"restarts":restarts
	}
	file.store_line(to_json(data))
	file.close()
	
	
func load_data():
	var file = File.new()
	if not file.file_exists("user://GameState.sav"):
		print("No file saved!")
		return
		  
	if file.open("user://GameState.sav", File.READ) != 0:
		print("Error opening file")
		file.close()
		return
		
	var load_data = {}
	load_data = parse_json(file.get_line())
	state = load_data["state"]
	restarts = load_data["restarts"]
	file.close()
	
func reset_money_manager():
	var file = File.new()
	if file.open("user://MoneyManager.sav", File.WRITE ) != 0:
		print("Error opening file")
		return
	var data = {
	"moneys":20,
	"time_multiplier":1,
	"rate_modifier":1,
	"current_arts":{
	"0":0,
	"1":0,
	"2":0,
	"3":0,
	"4":0
},
	"time":0,
	"artifacts":[],
	"treasures":[],
	"montized":false
	}
	file.store_line(to_json(data))
	file.close()

func reset_saves():
	var file = File.new()
	if file.open("user://MoneyManager.sav", File.WRITE ) != 0:
		print("Error opening file")
		return
	var data = {
	"moneys":20,
	"time_multiplier":1,
	"rate_modifier":1,
	"time":0,
	"current_arts":MoneyManager.current_arts_list(),
	"artifacts":MoneyManager.get_artifact_list(),
	"treasures":MoneyManager.get_treasure_list(),
	"montized":false
	}
	file.store_line(to_json(data))
	file.close()
	
	
	file = File.new()
	if file.open("user://Upgrade.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	data = {
	"current_level":0,
	"cost":25
	}
	file.store_line(to_json(data))
	file.close()
	
	
	file = File.new()
	if file.open("user://Upgrade2.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	data = {
	"current_level":0,
	"cost":1500
	}
	print(data["cost"])
	file.store_line(to_json(data))
	file.close()
	
	
	file = File.new()
	if file.open("user://Upgrade3.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	data = {
	"current_level":0,
	"cost":10000
	}
	print(data["cost"])
	file.store_line(to_json(data))
	file.close()
	
	file = File.new()
	if file.open("user://Upgrade4.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	data = {
	"current_level":0,
	"cost":25000
	}
	print(data["cost"])
	file.store_line(to_json(data))
	file.close()
	
	file = File.new()
	if file.open("user://Upgrade5.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	data = {
	"current_level":0,
	"cost":50000
	}
	print(data["cost"])
	file.store_line(to_json(data))
	file.close()
	
	file = File.new()
	if file.open("user://Ruins.sav", File.WRITE) != 0:
		print("Error opening file")
		return 
	data = {
	"explored":false,
	"level":0,
	"id":1,
	"gold_pc":1,
	"gold_pc_mult": 0,
	"rate": 0,
	"cost_to_open": 15,
	"gpc_upgrade_amout": 0,
	"montized": false
	}
	file.store_line(to_json(data))
	file.close()
