extends TextureButton

export var upgrade_cost_ratio = 1.25
export var upgrade_multiplier = 1
export var unlock_gpc = 15
export var current_level = 0
export var id = 1
export var cost = 1500
onready var description = $Description
onready var info_button = $TextureButton

func _ready():
	load_data()
	update_description()
	self.modulate = Color(1,1,1,.25)
	self.disabled = true
	description.visible = false

func _physics_process(_delta):
	
	if MoneyManager.get_ruins_gpc(id) >= unlock_gpc:
		self.disabled = false
		description.visible = true
		info_button.visible = true
	else:
		info_button.visible = false
		self.modulate = Color(1,1,1,1)
		self.disabled = true
		description.visible = false
		
	if not MoneyManager.check_amount(cost) and self.disabled == false:
		self.modulate = Color(0,0,0,.25)
	else:
		self.modulate = Color(1,1,1,1)

func _on_Upgrade2_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.set_ruins_rate(id,upgrade_multiplier)
		cost = int(cost*upgrade_cost_ratio)
		update_description()
		save_data()


func update_description():
	description.text = "Buy a minecart\n"+comma_sep(cost) + " Gold"

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
		description.text = "Minecarts bring "+str(upgrade_multiplier)+ " click\n worth of gold every " + str(MoneyManager.get_time_mult()) + "s\nTotal Carts: " + str(MoneyManager.get_ruins_rate(id))
	else:
		update_description()

func save_data():
	var file = File.new()
	if file.open("user://Upgrade2.sav", File.WRITE) != 0:
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
	if not file.file_exists("user://Upgrade2.sav"):
		print("No file saved!")
		return
		
	if file.open("user://Upgrade2.sav", File.READ) != 0:
		print("Error opening file")
		file.close()
		return
		
	var load_data = {}
	load_data = parse_json(file.get_line())
	print(load_data["cost"])
	current_level = load_data["current_level"]
	cost = load_data["cost"]
	file.close()
