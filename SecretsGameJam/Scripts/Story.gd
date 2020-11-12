extends Node2D


onready var text_box = $Panel/TextInterfaceEngine
onready var characters = $Panel/TextureRect
export var next_page_wait = 2
export var text_speed = .01
onready var speach = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.connect("story",self,"play_story")
	text_box.connect("buff_end", self, "_on_buff_end")
	text_box.connect("words", self, "word_audio")
	text_box.connect("tag_buff", self, "_on_tag_buff")
	
func _physics_process(_delta):
	if Input.is_action_pressed("skip"):
		text_box.set_turbomode(true)
	elif text_box._turbo: 
		text_box.set_turbomode(false) 
func play_story(chapter):
	self.visible = true
	text_box.set_color(Color(1,1,1))
	match chapter:
		0:
			chapter0()
		1:
			chapter1()
		2:
			chapter2()
			
			
			
			
func chapter2():
	print('playing story - Cahpter2')
	text_box.buff_text("This is strange", text_speed)
	text_box.buff_silence(.25)
	text_box.buff_text("...", 1)
	text_box.buff_silence(1)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("It looks like there's a page with some writing on it!", text_speed)
	text_box.buff_silence(1)
	text_box.buff_text(" I have just enough light to make out the words...", text_speed)
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text('"These ruins have riches beyond my wildest imaginations.', text_speed,"char1")
	text_box.buff_silence(1.5)
	text_box.buff_text(' I do have a very odd feeling everytime I step foot inside."', text_speed)
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("There's a strange enegery deep in bellow these floors.", text_speed)
	text_box.buff_silence(1)
	text_box.buff_text(' The further down I go the stronger the feeling gets."', text_speed)
	text_box.buff_silence(3)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text('"I hope it turns out to be somthing really special!', text_speed)
	text_box.buff_silence(1.5)
	text_box.buff_text(' Maybe if I give it to my wife she will forgive me for leaving her to come out here"', text_speed)
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text('"HA!', text_speed)
	text_box.buff_silence(1.5)
	text_box.buff_text(' I can dream cant I?"...', text_speed)
	text_box.buff_silence(3)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("I guess someone has beaten me here.", text_speed, "char0")
	text_box.buff_silence(1.5)
	text_box.buff_text(" It's strange that the enterances were all sealed when I found it.", text_speed)
	text_box.buff_silence(3)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("There's also pleanty of treaure left.", text_speed)
	text_box.buff_silence(1.5)
	text_box.buff_text(" Maybe there’s another entrance I overlooked?", text_speed)
	text_box.buff_silence(1.5)
	text_box.buff_text(" This place just keeps getting stranger.", text_speed)
	text_box.buff_silence(3)
	text_box.buff_clear()
	text_box.set_state(text_box.STATE_OUTPUT)
	
func chapter1():
	print('playing story - Cahpter1')
	change_character(0)
	text_box.buff_text("...", .5)
	text_box.buff_silence(1)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("What's This!?!?...", .02)
	text_box.buff_silence(2)
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
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("I wonder what it does...", text_speed)
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("Obviously it doesn't DO anything!",text_speed)
	text_box.buff_silence(1)
	text_box.buff_text(" It's just a normal, glowing, magical orb...",text_speed)
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.buff_silence(.25)
	text_box.buff_text("I'll have to take a closer look back at camp...",text_speed)
	text_box.buff_silence(2)
	text_box.buff_clear()
	text_box.set_state(text_box.STATE_OUTPUT)
	
func chapter0():
	print('playing story')
	change_character(0)
	text_box.buff_silence(2)
	text_box.buff_text("At long lost! I found it!", text_speed, 'speak')
	text_box.buff_silence(1)
	text_box.buff_text(" Dad would have loved to see this.", text_speed, 'speak')
	text_box.buff_silence(2)
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
	text_box.buff_text("Well I better set up camp and start exploring the ruins!", text_speed, 'speak')
	text_box.buff_silence(3)
	text_box.buff_clear()
	text_box.set_state(text_box.STATE_OUTPUT)


func _on_tag_buff(s):
	if s == "char1":
		change_character(1)
	elif s == "char0":
		change_character(0)
		
func word_audio():
	if not speach.playing:
		speach.play()


func _on_buff_end():
	print("Buff End")
	self.visible = false
	GameState.story_ended()
	
func change_character(character):
	print(characters.texture.get_region())
	match character:
		0:
			characters.texture.set_region(Rect2(4,4,366,74))
		1:
			characters.texture.set_region(Rect2(4,84,366,74))
