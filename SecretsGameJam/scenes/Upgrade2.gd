extends TextureButton

export var upgrade_cost_ratio = 1.25
export var upgrade_multiplier = 1
export var unlock_gpc = 15
export var current_level = 0
export var id = 1
export var cost = 1000
onready var description = $Description


func _ready():
	update_description()
	self.modulate = Color(1,1,1,.25)
	self.disabled = true

func _physics_process(delta):
	if MoneyManager.get_ruins_gpc(id) >= unlock_gpc:
		self.modulate = Color(1,1,1,1)
		self.disabled = false

func _on_Upgrade2_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.set_ruins_rate(id,upgrade_multiplier)
		cost = int(cost*upgrade_cost_ratio)
		update_description()


func update_description():
	description.text = "Hire a worker:"+str(MoneyManager.get_ruins_gpc(id)) + "/sec\n$"+comma_sep(cost)

func comma_sep(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res
