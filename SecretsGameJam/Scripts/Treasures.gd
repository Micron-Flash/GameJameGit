extends Node2D

var slot = preload("res://scenes/InventroySlot.tscn")
var art_slot = preload("res://scenes/Artifacts.tscn")
onready var grid = $Treasure/ScrollContainer/Spots
onready var grid2 = $Artifacts/ScrollContainer/Spots
onready var camera = get_node("/root/Game/Camera2D")
onready var button = $Artifacts/ScrollContainer/Spots
onready var sell = $MarginContainer/TextureRect/Sell
onready var activate = $MarginContainer/TextureRect/Activate
var button_group = null
var type = 0
var stat = 0
var artifact = null

func _ready():
	add_to_group("Persistanst")
	sell.visible = false
	activate.visible = false
	update_treasure([0])
	update_artifacts([0])
	MoneyManager.connect("more_treasure",self,"update_treasure")
	MoneyManager.connect("more_artifacts",self,"update_artifacts")
	MoneyManager.connect("sell_treasure",self,"sell_treasure")
	
	
func _physics_process(delta):
	if button_group.get_pressed_button():
		artifact = button_group.get_pressed_button().get_parent()
		sell.visible = true
		activate.visible = true
		type = artifact.type
		stat = artifact.stat
	else:
		sell.visible = false
		activate.visible = false
	
func update_treasure(treasure):
	print('setting')
	var max_slots = MoneyManager.get_max_treasure()
	for item in grid.get_children():
		item.queue_free()
	for slots in range(max_slots):
		var new_slot = slot.instance()
		grid.add_child(new_slot)
		new_slot.set_type(0)
		new_slot.id = slots
	for item in range(treasure.size()):
		print("item" + str(item))
		for spot in grid.get_children():
			if spot.get_id() == item:
				spot.set_type(int(treasure[item]))
				print(treasure[item])
				continue
			else:
				continue

func update_artifacts(artifacts):
	print('setting')
	var max_slots = MoneyManager.get_max_artifacts()
	for item in grid2.get_children():
		item.queue_free()
	for slots in range(max_slots):
		var new_slot = art_slot.instance()
		grid2.add_child(new_slot)
		new_slot.set_type(0)
		new_slot.id = slots
	for item in range(artifacts.size()):
		for spot in grid2.get_children():
			if spot.get_id() == item:
				spot.set_type(int(artifacts[item]))
			else:
				continue
	button_group = button.get_child(0).get_node("./Button").get_button_group()



func _on_Back_pressed():
	camera.position = Vector2(0,0)


func _on_Sell_pressed():
	if artifact:
		artifact.sell()


func _on_Activate_pressed():
	artifact.activated()
	GameState.reset(stat,type)
	
