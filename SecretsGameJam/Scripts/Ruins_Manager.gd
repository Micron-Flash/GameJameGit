extends Node2D

export var explored = false
export var level = 1
export var id = 1
export var gold_pc = 1
export var rate = 0 #basically workers 2 workers means 2 * gold_pc
export var t_rate = 0
export var a_rate = 0
export var cost_to_open = 100
export var new_floor_rate = 1.78
export var first_floor_cost = 120
export var a_rates = {
	1:0.01,
	2:0.2,
	3:0.5
}
export var t_rates = {
	1:0.5,
	2:1,
	3:1.5
}
onready var unexplored_board = $Unexplored
onready var unexplored_board_label = $Unexplored/Label
onready var stat_board = $CurrentStats
onready var stat_board_label = $CurrentStats/Stats
onready var camp_site = $Campsite



func _ready():
	unexplored_board_label.text = "Click To explore\n$" + str(cost_to_open)
	stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(gold_pc)+"\nTreasure Chance:"+str(t_rate)+"%\nArtifact Chance:"+str(a_rate)+"%"
	camp_site.visible = false
	a_rate = a_rates[level]
	t_rate = t_rates[level]
func _on_TextureButton_mouse_entered():
	if explored == false:
		unexplored_board.visible = true
	else:
		stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(gold_pc)+"\nTreasure Chance per Click:"+str(t_rate)+"%\nArtifact Chance per Click:"+str(a_rate)+"%"
		stat_board.visible = true

func _on_TextureButton_mouse_exited():
	if explored == false:
		unexplored_board.visible = false
	else:
		stat_board.visible = false


func _on_TextureButton_pressed():
	if not explored:
		if MoneyManager.check_amount(cost_to_open):
			MoneyManager.remove_money(cost_to_open)
			unexplored_board.visible = false
			stat_board.visible = true
			explored = true
			camp_site.visible = true
	else:
		MoneyManager.add_money(gold_pc)
		MoneyManager.run_rng()
		
		
func upgrade():
	level += 1
	a_rate = a_rates[level]
	t_rate = t_rates[level]
