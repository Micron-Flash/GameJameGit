extends TextureButton


onready var empty = $Empty
onready var one = $"1"
onready var two = $"2"
onready var three = $"3"
var id

func _ready():
	empty.visible = false
	one.visible = false
	two.visible = false
	three.visible = false

func get_id():
	return id
	
func set_type(_id):
	match _id:
		0:
			self.texture_normal = empty.texture
		1:
			self.texture_normal = one.texture
		2:
			self.texture_normal = two.texture
		3:
			self.texture_normal = three.texture
