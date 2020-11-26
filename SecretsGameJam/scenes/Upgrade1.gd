extends TextureButton

export var upgrade_cost_ratio = 1.27
export var base_upgrade_amount = 2
export var upgrade_multiplier = 1
export var current_level = 0
export var id = 1
export var cost = 75
onready var description = $Description


func _ready():
	load_data()
	MoneyManager.connect("new_level",self,"update_level")
	update_description()

func update_level():
	current_level += 1
	save_data()
	#upgrade_multiplier = current_level*2

func _physics_process(_delta):
	
	if not MoneyManager.check_amount(cost):
		self.modulate = Color(0,0,0,.25)
	else:
		self.modulate = Color(1,1,1,1)

func _on_Upgrade1_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.upgrade_ruins_gpc(id,(base_upgrade_amount))
		cost = int(cost*(upgrade_cost_ratio))
		update_description()
		save_data()


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
	if MoneyManager.get_ruins_mult(id) > 0:
		upgrade_multiplier = MoneyManager.get_ruins_mult(id)
	else:
		upgrade_multiplier
	print(button_pressed)
	if button_pressed:
		description.text = "+" + str(base_upgrade_amount) + ' Gold per Click'
	else:
		update_description()
	

func save_data():
	var file = File.new()
	if file.open("user://Upgrade.sav", File.WRITE) != 0:
		print("Error opening file")
		return
	var data = {
	"current_level":current_level,
	"cost":cost
	}
	print(data["cost"])
	file.store_line(to_json(data))
	file.close()
	
	
func load_data():
	print("Loading Upgrade")
	var file = File.new()
	if not file.file_exists("user://Upgrade.sav"):
		print("No file saved!")
		file.close()
		return
		
	if file.open("user://Upgrade.sav", File.READ) != 0:
		print("Error opening file")
		file.close()
		return
		
	var load_data = {}
	load_data = parse_json(file.get_line())
	current_level = load_data["current_level"]
	cost = load_data["cost"]
	file.close()
