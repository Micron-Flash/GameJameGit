extends Node2D

var slot = preload("res://scenes/InventroySlot.tscn")
onready var grid = $Treasure/ScrollContainer/Spots
onready var grid2 = $Artifacts/ScrollContainer/Spots
onready var camera = get_node("/root/Game/Camera2D")


func _ready():
	update_treasure([0])
	update_artifacts([0])
	MoneyManager.connect("more_treasure",self,"update_treasure")
	MoneyManager.connect("more_artifacts",self,"update_artifacts")

func update_treasure(treasure):
	print('setting')
	var max_slots = MoneyManager.get_max_treasure()
	var slot_count = max_slots - grid.get_child_count()
	for slots in range(slot_count):
		var new_slot = slot.instance()
		grid.add_child(new_slot)
		new_slot.set_type(0)
		new_slot.id = slots
	for item in range(treasure.size()):
		for spot in grid.get_children():
			if spot.get_id() == item:
				spot.set_type(treasure[spot.get_id()])
			else:
				continue

func update_artifacts(artifacts):
	print('setting')
	var max_slots = MoneyManager.get_max_artifacts()
	var slot_count = max_slots - grid2.get_child_count()
	for slots in range(slot_count):
		var new_slot = slot.instance()
		grid2.add_child(new_slot)
		new_slot.set_type(0)
		new_slot.id = slots
	for item in range(artifacts.size()):
		for spot in grid2.get_children():
			if spot.get_id() == item:
				spot.set_type(artifacts[spot.get_id()])
			else:
				continue

func _on_Back_pressed():
	camera.position = Vector2(0,0)
