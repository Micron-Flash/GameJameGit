extends TextureButton

export var upgrade_cost_ratio = 1.25
export var upgrade_multiplier = 2
export var current_level = 0
export var id = 1
export var cost = 75
onready var description = $Description


func _ready():
	update_description()

func _on_Upgrade1_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.set_ruins_gpc(id,upgrade_multiplier)
		cost = int(cost*upgrade_cost_ratio)
		update_description()


func update_description():
	description.text = "Gold per click:"+str(MoneyManager.get_ruins_gpc(id)+upgrade_multiplier) + "\n$"+str(cost)