extends Node

signal story(chapter)
signal game_on()
signal stop()
export var state = 0
export var starting_state = 0
export var starting_chapter = 0
onready var camera = get_node("/root/Game/Camera2D")

func _ready():
	camera.position = Vector2(0,-400)


func story_playing(chapter):
	print('sending signal')
	state = 0
	emit_signal("story",chapter)

func story_ended():
	state = 1
	emit_signal("game_on")
	
func play():
	state = 1
	emit_signal("game_on")

func stop():
	state = 2
	emit_signal("stop")
	
func get_state():
	return state

func start_game():
	camera.position = Vector2(0,0)
