extends Node2D

export var explored = false
export var level = 0
export var id = 1
export var gold_pc = 10
export var rate = 0 #basically workers 2 workers means 2 * gold_pc
export var cost_to_open = 100
export var new_floor_rate = 1.78
export var first_floor_cost = 120
onready var unexplored_board = $Unexplored
onready var unexplored_board_label = $Unexplored/Label
onready var stat_board = $CurrentStats
onready var stat_board_label = $CurrentStats/Stats
onready var camp_site = $Campsite
onready var path = $Path2D
const worker = preload("res://Person.tscn")

func _ready():
	
	unexplored_board_label.text = "Click To explore\n$" + str(cost_to_open)
	stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(gold_pc)+"\nTreasure Chance: .2%\nArtifact Chance:0.01%"
	camp_site.visible = false
	
	
func _on_TextureButton_mouse_entered():
	if explored == false:
		unexplored_board.visible = true
	else:
		stat_board_label.text = "Floors Unlocked:"+str(level)+"\nGold per click:"+str(gold_pc)+"\nTreasure Chance: .2%\nArtifact Chance:0.01%"
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
		var work = worker.instance()
		path.add_child(work)
		work.start_trip(gold_pc)
