extends Node2D

onready var ruin = get_node("../Ruins1")
onready var game = get_node("..")
onready var tree = get_node("../Trees")
onready var camera = get_node("/root/Game/Camera2D")
onready var support = $"TextureRect/GridContainer/Support Boosts/Label"
onready var refresh = $Options/ResartGame
var ruins = preload("res://scenes/Ruins1.tscn")
var played = false
var montized = false


func _ready():
	refresh.visible = false
	support.text = "Premium Boosts:\nNot Enabled"
	load_data()
	
func _physics_process(delta):
	if WebMonetization.is_paying() and montized == false:
		support.text = "Premium Boosts:\nEnabled!"
		montized = true
	elif not WebMonetization.is_paying() and montized == true:
		support.text = "Premium Boosts:\nNot Enabled"
		montized = false
		
		
	
func _on_Play_pressed():
	
	GameState.start_game()
	if played == false:
		GameState.story_playing(0)
		played = true
		save_data()
	else:
		GameState.story_ended()

		
		
func _on_TextureButton_pressed():
	camera.position = Vector2(0,-400)

func save_data():
	var file = File.new()
	if file.open("user://Played.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	var data = {
		"Played": played,
		"montized":montized
	}
	file.store_line(to_json(data))
	file.close()
	
	
func load_data():
	var file = File.new()
	if not file.file_exists("user://Played.sav"):
		print("No file saved!")
		return
		
	if file.open("user://Played.sav", File.READ) != 0:
		print("Error opening file")
		file.close()
		return
		
	var load_data = {}
	load_data = parse_json(file.get_line())
	print(load_data)
	played = load_data["Played"]
	montized = load_data["montized"]
	file.close()


func _on_Support_Boosts_pressed():
	camera.position = Vector2(600,-400)


func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(meta)


func _on_TextureButton2_pressed():
	camera.position = Vector2(0,-400)


func _on_Instructions_pressed():
	camera.position = Vector2(-600,-400)


func _on_Credits_pressed():
	camera.position = Vector2(0,-800)


func _on_Options_pressed():
	camera.position = Vector2(-600,-800)


func _on_Reset_data_pressed():
	GameState.reset_money_manager()
	MoneyManager.load_data()
	refresh.visible = true
	var files = []
	var dir = Directory.new()
	dir.open("user://")
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		print(file)
		if file == "":
			break
		elif file.ends_with(".sav"):
			dir.remove(file)
			files.append(file)
	print(files)
	dir.list_dir_end()



