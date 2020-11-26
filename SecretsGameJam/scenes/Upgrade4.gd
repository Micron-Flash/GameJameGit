extends TextureButton

export var upgrade_cost_ratio = 1.5
export var current_level = 1
export var unlock_rate = 500
export var unlock_gpc = 130
export var max_levels = 100
export var id = 1
export var cost = 25000
onready var description = $Description
onready var info_button = $TextureButton

func _ready():
	load_data()
	update_description()
	self.modulate = Color(1,1,1,1)
	self.disabled = true
	description.visible = false
	
func _physics_process(_delta):
	if MoneyManager.get_rate() >= unlock_rate and MoneyManager.get_ruins_gpc(id) >= unlock_gpc:
		self.disabled = false
		description.visible = true
		info_button.visible = true
	else:
		self.modulate = Color(1,1,1,1)
		self.disabled = true
		description.visible = false
		info_button.visible = false
	
	if not MoneyManager.check_amount(cost) and self.disabled == false:
		self.modulate = Color(0,0,0,.25)
	else:
		self.modulate = Color(1,1,1,1)

func _on_Upgrade4_pressed():
	if MoneyManager.check_amount(cost):
		MoneyManager.remove_money(cost)
		MoneyManager.update_time_multiplyer(0.01)
		cost = int(cost*upgrade_cost_ratio)
		update_description()
		current_level += 1
		if current_level >= max_levels:
			self.hide()
		save_data()

func update_description():
	description.text = "Increase minecarts speed\nby .01s\n"+ comma_sep(cost) + " Gold"

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
		description.text = "Decreases the amount of time\nit takes for minecarts\nto bring back gold"
	else:
		update_description()

func save_data():
	var file = File.new()
	if file.open("user://Upgrade4.sav", File.WRITE) != 0:
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
	if not file.file_exists("user://Upgrade4.sav"):
		print("No file saved!")
		return
		
	if file.open("user://Upgrade4.sav", File.READ) != 0:
		print("Error opening file")
		file.close()
		return
		
	var load_data = {}
	load_data = parse_json(file.get_line())
	print(load_data["cost"])
	current_level = load_data["current_level"]
	cost = load_data["cost"]
	file.close()
