extends Node2D

export var explored = false
export var level = 0
export var id = 1
export var gold_pc = 1
export var gold_pc_mult = 0
export var boost_mult = 1
export var rate = 0 #basically workers 2 workers means 2 * gold_pc
export var t_rate = 0
export var a_rate = 0
export var cost_to_open = 100
export var new_floor_rate = 1.78
export var first_floor_cost = 120
export var gpc_upgrade_amout = 0
var tween_values = [Vector2(1,1), Vector2(1.01,1.01)]
onready var time = $Timer
export var a_rates = {
	0:10,
	1:10,
	2:10.02,
	3:10.05,
	4:0.07,
	5:.09
}
export var t_rates = {
	0:10,
	1:10, 
	2:11,
	3:11.5,
	4:11.75, 
	5:12   
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
	light.visible = false
	GameState.connect("game_on",self,"_start_tween")
	unexplored_board_label.text = "Click To set up camp\n" + str(cost_to_open) + " Gold"
	stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(get_gold_pc())+"\nTreasure Chance:"+str(t_rate)+"%\nArtifact Chance:"+str(a_rate)+"%"
	camp_site.visible = false
	a_rate = a_rates[level]
	t_rate = t_rates[level]
	
func _on_TextureButton_mouse_entered():
	if GameState.get_state() == 1:
		if explored == false:
			unexplored_board.visible = true
		else:
			stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(get_gold_pc())+"\nTreasure Chance:"+str(t_rate)+"%\nArtifact Chance:"+str(a_rate)+"%"
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
		else:
			MoneyManager.add_money(get_gold_pc())
			MoneyManager.run_rng()
		
		
func upgrade():
	level += 1
	if level > 1:
		gold_pc_mult += 2
	a_rate = a_rates[level]
	t_rate = t_rates[level]
	
func upgrade_gpc(amount):
	gold_pc += amount


func _start_tween():
	if explored == false:
		tween.interpolate_property(self, "scale", tween_values[0] , tween_values[1],.3 ,Tween.TRANS_SINE, Tween.EASE_IN)    
		tween.start()


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
