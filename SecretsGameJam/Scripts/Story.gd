extends Node2D


onready var text_box = $Panel/TextInterfaceEngine

export var next_page_wait = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	text_box.connect("buff_end", self, "_on_buff_end")
	text_box.set_color(Color(1,1,1))
	text_box.buff_silence(1)
	text_box.buff_text("At long lost! I found it!", 0.06)
	text_box.buff_silence(.5)
	text_box.buff_text(" Dad would have loved to see this.", 0.06)
	text_box.buff_silence(next_page_wait)
	text_box.buff_clear()
	text_box.buff_text("Huh...", 0.06)
	text_box.buff_silence(.75)
	text_box.buff_text(" Its exactly how it looks in my dreams...", 0.06)
	text_box.buff_silence(.5)
	text_box.buff_text(" Those stories Dad told were really detailed.", 0.06)
	text_box.buff_silence(next_page_wait)
	text_box.buff_clear()
	text_box.buff_text("I hope the storeis about all the treasuers are just as real as this place.", 0.06)
	text_box.buff_silence(1)
	text_box.buff_text(" Well I beter set up camp and start exploring!", 0.06)
	text_box.buff_silence(next_page_wait)
	text_box.buff_clear()
	text_box.set_state(text_box.STATE_OUTPUT)



func _on_buff_end():
	print("Buff End")
	self.visible = false
	pass
