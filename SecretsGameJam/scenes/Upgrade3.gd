extends TextureButton

export var upgrade_cost_ratio = 2.5
export var current_level = 1
export var unlock_rate = 100
export var max_levels = 3
export var id = 1
export var cost = 10000
onready var description = $Description


func _ready():
	update_description()
	self.modulate = Color(1,1,1,.25)
	self.disabled = true
	
func _physics_process(delta):
	if MoneyManager.get_rate() >= unlock_rate:
		self.modulate = Color(1,1,1,1)
		self.disabled = false

func _on_Upgrade3_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.upgrade_ruins_level(id)
		cost = int(cost*upgrade_cost_ratio)
		update_description()
		current_level += 1
		if current_level >= max_levels:
			self.hide()


func update_description():
	description.text = "Unlock Next Floor\n$"+ comma_sep(cost)

func comma_sep(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res
