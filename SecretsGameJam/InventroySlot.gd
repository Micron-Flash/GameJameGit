extends TextureRect


onready var empty = $Empty
onready var one = $"1"
onready var two = $"2"
onready var three = $"3"
onready var sell_board = $TextureRect
onready var sell_board_text = $TextureRect/Label
onready var button = $Button
var id
var item_id
var base_price = {
	1:2501,
	2:9992,
	3:75042
}
func _ready():
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
			
		2:
			button.texture_normal = two.texture

		3:
			button.texture_normal = three.texture


func _on_Button_pressed():
	if item_id != 0:
		MoneyManager.sell_item(id,base_price[item_id])
		self.queue_free()



func _on_Button_mouse_entered():
	if item_id != 0:
		var price_mode = MoneyManager.get_treasure_price_mod()
		sell_board_text.text = str(base_price[item_id]*price_mode)+ " Gold"
		sell_board.visible = true


func _on_Button_mouse_exited():
	if item_id != 0:
		sell_board.visible = false
