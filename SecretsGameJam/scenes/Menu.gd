extends TextureButton

onready var camera = get_node("/root/Game/Camera2D")
onready var parent = get_node("/root/Game/Control")


func _on_Menu_pressed():
	parent.visible = false
	camera.position = Vector2(0,-400)
