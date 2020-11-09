extends TextureButton

export var upgrade_cost_ratio = 10
export var current_level = 1
export var unlock_rate = 100
export var max_levels = 3
export var id = 1
export var cost = 10000
onready var description = $Description
onready var info_button = $TextureButton

func _ready():
	update_description()
	self.modulate = Color(1,1,1,1)
	self.disabled = true
	description.visible = false
	
func _physics_process(_delta):
	if MoneyManager.get_rate() >= unlock_rate:
		self.disabled = false
		description.visible = true
		info_button.visible = true
	else:
		self.modulate = Color(1,1,1,1)
		self.disabled = true
		description.visible = false
		info_button.visible = false
	
	if not MoneyManager.check_amount(cost) and self.disabled == false:
		self.modulate = Color(1,1,1,.25)
	else:
		self.modulate = Color(1,1,1,1)

func _on_Upgrade3_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.upgrade_ruins_level(id)
		cost = int(cost*upgrade_cost_ratio)
		update_description()
		current_level += 1
		if current_level == 2:
			GameState.story_playing(1)
		if current_level >= max_levels:
			GameState.story_playing(2)
			self.hide()


func update_description():
	description.text = "Uncover Next Floor\n"+ comma_sep(cost) + " Gold"

func comma_sep(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res


func _on_TextureButton_toggled(button_pressed):
	if button_pressed and self.disabled == false:
		description.text = "+2x Gold Per Click\n+ Increased chance to find\n Artifacts and Treasues"
	else:
		update_description()
