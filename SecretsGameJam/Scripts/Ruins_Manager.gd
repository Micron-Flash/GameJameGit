extends Node2D

export var explored = false
export var level = 0
export var id = 1
export var gold_pc = 1
export var gold_pc_mult = 0
export var moni_mult = 2
export var boost_mult = 1
export var rate = 0 #basically workers 2 workers means 2 * gold_pc
export var t_rate = 0
export var a_rate = 0
export var cost_to_open = 15
export var new_floor_rate = 1.78
export var first_floor_cost = 120
export var gpc_upgrade_amout = 0
var tween_values = [Vector2(1,1), Vector2(1.01,1.01)]
onready var time = $Timer
var montized = false
export var a_rates = {
	0:0,
	1:0,
	2:0.2,
	3:0.55,
	4:1,
	5:1.5
}
export var t_rates = {
	0:0,
	1:0.01, 
	2:1,
	3:1.5,
	4:1.75, 
	5:2   
}
onready var tween = $Tween
onready var unexplored_board = $Unexplored
onready var unexplored_board_label = $Unexplored/Label
onready var stat_board = $CurrentStats
onready var stat_board_label = $CurrentStats/Stats
onready var camp_site = $Campsite
onready var light = $Door/Light2D
var rng = RandomNumberGenerator.new()

func _ready():
	
	load_data()
	stat_board.visible = false
	unexplored_board.visible = false
	camp_site.visible = false
	GameState.connect("game_on",self,"_start_tween")

func _physics_process(delta):
	if WebMonetization.is_paying() and montized == false:
		print("Upgrading Multiplier")
		gold_pc_mult += moni_mult
		montized = true
	elif not WebMonetization.is_paying() and montized == true:
		print("DownGrading Multiplier")
		gold_pc_mult -= moni_mult
		montized = false
		
func start_up():
	light.visible = false
	unexplored_board.visible = false
	stat_board.visible = false
	unexplored_board_label.text = "Click To set up camp\n" + str(cost_to_open) + " Gold"
	if gold_pc_mult > 0 or montized == true:
		stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(gold_pc_mult)+" x "+str(gold_pc)+"\nTreasure Chance:"+str(t_rate)+"%\nArtifact Chance:"+str(a_rate)+"%"
	else:
		stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(gold_pc)+"\nTreasure Chance:"+str(t_rate)+"%\nArtifact Chance:"+str(a_rate)+"%"
	camp_site.visible = false
	a_rate = a_rates[level]
	t_rate = t_rates[level]

func _on_TextureButton_mouse_entered():
	if GameState.get_state() == 1:
		if explored == false:
			unexplored_board.visible = true
		else:
			if gold_pc_mult > 0:
				stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(get_gold_pc())+" ("+str(gold_pc_mult)+"x"+str(gold_pc)+")"+"\nTreasure Chance:"+str(t_rate)+"%\nArtifact Chance:"+str(a_rate)+"%"
			else:
				stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(gold_pc)+"\nTreasure Chance:"+str(t_rate)+"%\nArtifact Chance:"+str(a_rate)+"%"
			stat_board.visible = true

func _on_TextureButton_mouse_exited():
	if explored == false:
		unexplored_board.visible = false
	else:
		stat_board.visible = false


func _on_TextureButton_pressed():
	if GameState.get_state() == 1:
		if not explored:
			if MoneyManager.check_amount(cost_to_open):
				MoneyManager.remove_money(cost_to_open)
				unexplored_board.visible = false
				stat_board.visible = true
				explored = true
				upgrade()
				light.visible = true
				camp_site.visible = true
				stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(gold_pc)+"\nTreasure Chance:"+str(t_rate)+"%\nArtifact Chance:"+str(a_rate)+"%"
		else:
			MoneyManager.add_money(get_gold_pc())
			MoneyManager.run_rng()
	save_data()
		
		
func upgrade():
	level += 1
	if level > 1:
		gold_pc_mult += 2
	a_rate = a_rates[level]
	t_rate = t_rates[level]
	save_data()
	
func upgrade_gpc(amount):
	gold_pc += amount
	save_data()
func upgrade_mult(amount):
	gold_pc_mult += amount
	save_data()

func _start_tween():
	if explored == false:
		tween.interpolate_property(self, "scale", tween_values[0] , tween_values[1],.3 ,Tween.TRANS_SINE, Tween.EASE_IN)    
		tween.start()

func upgrade_rate(amount):
	rate += amount
	save_data()

func _on_Tween_tween_completed(_object, _key):
	tween_values.invert()
	if explored == false:
		if tween_values[0] == Vector2(1,1):
			time.wait_time = 3.5
			time.one_shot = true
			time.start()
			yield(time,"timeout")
			if explored == false:
				_start_tween() 
			else:
				self.scale = Vector2(1,1)
		else:
			_start_tween()
	else:
		self.scale = Vector2(1,1)

func get_gold_pc():
	if gold_pc_mult > 0:
		return gold_pc*gold_pc_mult*boost_mult
	else:
		return gold_pc*boost_mult

func save_data():
	var file = File.new()
	if file.open("user://Ruins.sav", File.WRITE) != 0:
		print("Error opening file")
		return 
	var data = {
	"explored":explored,
	"level":level,
	"id":id,
	"gold_pc":gold_pc,
	"gold_pc_mult": gold_pc_mult,
	"rate": rate,
	"cost_to_open": cost_to_open,
	"gpc_upgrade_amout": gpc_upgrade_amout,
	"montized": montized
	}
	file.store_line(to_json(data))
	file.close()
	
	
func load_data():
	var file = File.new()
	if not file.file_exists("user://Ruins.sav"):
		print("No file saved!")
		return
		
	if file.open("user://Ruins.sav", File.READ) != 0:
		print("Error opening file")
		file.close()
		return
		
	var load_data = {}
	load_data = parse_json(file.get_line())
	explored = load_data["explored"]
	level = int(load_data["level"])
	id = int(load_data["id"])
	gold_pc = int(load_data["gold_pc"])
	gold_pc_mult = int(load_data["gold_pc_mult"])
	rate = int(load_data["rate"])
	cost_to_open = int(load_data["cost_to_open"])
	gpc_upgrade_amout = int(load_data["gpc_upgrade_amout"])
	montized = bool(load_data["montized"])
	print(load_data["rate"])
	start_up()
	file.close()
