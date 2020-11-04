extends PathFollow2D

var _timer = null
var going = true
onready var sprite = $Person
onready var tween = $Tween
onready var tween_values = [1, 0]
export var speed = 3
var looping = false
var amount = 0
	
func start_trip(gold):
	amount = gold
	_start_tween()

func _physics_process(_delta):
	if tween_values[0] == 1:
		sprite.flip_h = true
		going = true
	elif tween_values[0] == 0:
		sprite.flip_h = false
		going = false
	
func _start_tween():
	speed = MoneyManager.get_speed()
	tween.interpolate_property(self, "unit_offset", tween_values[0] , tween_values[1], speed/2 ,Tween.TRANS_LINEAR, Tween.EASE_IN)    
	tween.start()

func _on_Tween_tween_completed(object, key):
	if self.unit_offset == 0:
		tween_values.invert()
		_start_tween()
	else:
		if looping:
			tween_values.invert()
			MoneyManager.finish_trip(amount)
			_start_tween()
		else:
			tween_values.invert()
			MoneyManager.finish_trip(amount)
			self.queue_free()
