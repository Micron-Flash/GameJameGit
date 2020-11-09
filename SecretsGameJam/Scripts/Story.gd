extends Node2D


onready var text_box = $Panel/TextInterfaceEngine

export var next_page_wait = 2
export var text_speed = .03
var speach_blips = 5
onready var speach = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.connect("story",self,"play_story")
	text_box.connect("buff_end", self, "_on_buff_end")
	text_box.connect("words", self, "word_audio")
func play_story(chapter):
	self.visible = true
	text_box.set_color(Color(1,1,1))
	match chapter:
		0:
			chapter0()
		1:
			chapter1()
			
			
			
func chapter1():
	print('playing story - Cahpter1')
	text_box.buff_text("...", .5)
	text_box.buff_silence(1.5)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("What's This!?!?...", .02)
	text_box.buff_silence(2.5)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("It looks to be some type of articfact!", text_speed)
	text_box.buff_silence(1.5)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("It almost looks like its glowing", text_speed)
	text_box.buff_silence(.25)
	text_box.buff_text("...", 1)
	text_box.buff_silence(1.5)
	text_box.buff_text(" It is glowing!!!!!!", text_speed)
	text_box.buff_silence(2.5)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("I wonder what it does...", text_speed)
	text_box.buff_silence(2.5)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text(" Of course it doesn't DO anything!",text_speed)
	text_box.buff_silence(1.5)
	text_box.buff_text(" It's just a silly, glowing, magical orb...",text_speed)
	text_box.buff_silence(2.5)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("I'll have to take a closer look back at camp...",text_speed)
	text_box.buff_silence(2.5)
	text_box.buff_clear()
	text_box.set_state(text_box.STATE_OUTPUT)
	
func chapter0():
	print('playing story')
	text_box.buff_silence(2)
	text_box.buff_text("At long lost! I found it!", text_speed, 'speak')
	text_box.buff_silence(1.5)
	text_box.buff_text(" Dad would have loved to see this.", text_speed, 'speak')
	text_box.buff_silence(1.5)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("Huh...", text_speed, 'speak')
	text_box.buff_silence(.75)
	text_box.buff_text(" Its exactly how it looks in my dreams...", text_speed, 'speak')
	text_box.buff_silence(.75)
	text_box.buff_text(" Those stories Dad told were really detailed.", text_speed, 'speak')
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("I hope the storeis about all the treasures are just as real as this place.", text_speed, 'speak')
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text(" Well I better set up camp and start exploring!", text_speed, 'speak')
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.set_state(text_box.STATE_OUTPUT)


func word_audio():
	if not speach.playing:
		speach.play()


func _on_buff_end():
	print("Buff End")
	self.visible = false
	GameState.story_ended()
