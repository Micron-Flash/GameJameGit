extends Label


func _ready():
	MoneyManager.connect("new_money",self,"update_money")

func update_money(money,treasure,artifacts):
	self.text = "Gold:$"+str(money)+"\nTreasures:"+str(treasure)+"\nArtifacts:"+str(artifacts)+""
