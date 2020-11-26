extends TextureButton

onready var camera = get_node("/root/Game/Camera2D")


func _on_Inventory_pressed():
	camera.position = Vector2(600,0)

