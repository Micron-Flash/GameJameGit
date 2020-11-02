extends TextureButton

export var upgrade_cost_ratio = 1.25
export var upgrade_multiplier = 1
export var current_level = 0
export var id = 1
export var cost = 1000
onready var description = $Description


func _ready():
	update_description()

func _on_Upgrade1_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.set_ruins_rate(id,upgrade_multiplier)
		cost = int(cost*upgrade_cost_ratio)
		update_description()


func update_description():
	description.text = "Hire a worker:"+str(MoneyManager.get_ruins_gpc(id)) + "/sec\n$"+str(cost)
