extends TextureButton

export var upgrade_cost_ratio = 1.25
export var base_upgrade_amount = 2
export var upgrade_multiplier = 1
export var current_level = 0
export var id = 1
export var cost = 75
onready var description = $Description


func _ready():
	MoneyManager.connect("new_level",self,"update_level")
	update_description()

func update_level():
	current_level += 1
	upgrade_multiplier = current_level*2

func _physics_process(_delta):
	
	if not MoneyManager.check_amount(cost):
		self.modulate = Color(1,1,1,.25)
	else:
		self.modulate = Color(1,1,1,1)

func _on_Upgrade1_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.upgrade_ruins_gpc(id,(base_upgrade_amount*upgrade_multiplier))
		cost = int(cost*(upgrade_cost_ratio))
		update_description()


func update_description():
	description.text = "Larger Treasure Sacks\n"+comma_sep(cost)+" Gold"
	


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
	print(button_pressed)
	if button_pressed:
		description.text = "+" + str(base_upgrade_amount*upgrade_multiplier) + ' Gold per Click'
	else:
		update_description()
