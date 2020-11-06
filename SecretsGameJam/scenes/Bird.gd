extends PathFollow2D

onready var sprite = $AnimatedSprite
onready var tween = $Tween
onready var tween_values = [1, 0]
export var speed = 5

func _ready():
	_start_tween()

func _physics_process(_delta):
	if tween_values[0] == 1:
		sprite.flip_h = true
	elif tween_values[0] == 0:
		sprite.flip_h = false
	
func _start_tween():
	tween.interpolate_property(self, "unit_offset", tween_values[0] , tween_values[1], speed ,Tween.TRANS_LINEAR, Tween.EASE_IN)    
	tween.start()

func _on_Tween_tween_completed(object, key):
	tween_values.invert()
	_start_tween()

