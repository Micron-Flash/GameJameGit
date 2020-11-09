extends Label


func _ready():
	MoneyManager.connect("new_money",self,"update_money")

func update_money(money,treasure,artifacts):
	self.text = "Gold: " + comma_sep(money)+"\nTreasures:"+str(treasure)+"\nArtifacts:"+str(artifacts)+""
	
func comma_sep(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += ","
		res += string[i]

	return res

func _on_Upgrade3_pressed():
	pass # Replace with function body.
