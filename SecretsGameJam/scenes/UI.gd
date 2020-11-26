extends Control

onready var camera = get_node("/root/Game/Camera2D")
onready var treasure = get_node("../Treasures")
onready var game = get_node("..")

func _physics_process(_delta):
	self.set_global_position(Vector2(camera.position.x+600,camera.position.y+200))

func _ready():
	GameState.connect("reset",self,"_reset")
	GameState.connect("game_on",self,"game_on")
	self.visible = false

func game_on():
	self.visible = true

func _reset(stat,type):
	var new_self = load("res://scenes/UI.tscn").instance()
	game.add_child_below_node(treasure,new_self,true) 
	new_self.visible = true
	self.queue_free()


func _on_TextureButton_pressed():
	pass # Replace with function body.
