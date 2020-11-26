extends TextureRect


onready var empty = $Empty
onready var one = $"1"
onready var two = $"2"
onready var three = $"3"
onready var four = $"4"
onready var sell_board = $TextureRect
onready var sell_board_text = $TextureRect/Label
onready var button = $Button
var rng = RandomNumberGenerator.new()
var id
var item_id
var max_gpc = 1
var min_gpc = 1
var gpc_rng = 0
var type = 0
var stat = 0
func _ready():
	button.disabled = true
	sell_board.visible = false
	empty.visible = false
	one.visible = false
	two.visible = false
	three.visible = false

func get_id():
	return id
	
func set_type(_id):
	item_id = _id
	match _id:
		0:
			pass
		1:
			button.texture_normal = one.texture
			button.disabled = false
			var rarity = rng.randf()
			if rarity > 0:
				max_gpc = 2
				min_gpc = 2
			if rarity > .65:
				max_gpc = 3
				min_gpc = 2
			if rarity > .75:
				max_gpc = 5
				min_gpc = 2
			if rarity > .95:
				max_gpc = 10
				min_gpc = 3
			print(rarity)
			gpc_rng = rng.randi_range(min_gpc, max_gpc)
			type = 1
			stat = gpc_rng
			sell_board_text.text = str(gpc_rng)+"X Gold Per Click\nSell:10,000 Gold"
		2:
			button.texture_normal = two.texture
			button.disabled = false
			type = 2
			stat = .02
			sell_board_text.text = "+.02s MineCart spd\nSell:10,000 Gold"
		3:
			button.texture_normal = three.texture
			button.disabled = false
			type = 3
			stat = 1
			sell_board_text.text = "+1 Treasure Slot\nSell:10,000 Gold"
		4:
			button.texture_normal = four.texture
			button.disabled = false
			type = 4
			stat = 1
			sell_board_text.text = "+1 Artifact Slot\nSell:10,000 Gold"
			

func _on_Button_mouse_entered():
	if item_id != 0:
		sell_board.visible = true


func _on_Button_mouse_exited():
	if item_id != 0:
		sell_board.visible = false


func _on_Button_toggled(button_pressed):
	pass # Replace with function body.

func sell():
	MoneyManager.sell_artifact(id,10000)
	self.queue_free() 
	 
func activated():
	MoneyManager.sell_all_artifact()

