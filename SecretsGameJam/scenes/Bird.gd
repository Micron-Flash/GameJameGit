extends PathFollow2D

onready var sprite = $AnimatedSprite
onready var tween = $Tween
onready var tween_values = [0, 1]
export var speed = 10
export var wait_time_max = 20
export var wait_time_min = 3
var rng = RandomNumberGenerator.new()

func _ready():
	_start_tween()


func _start_tween():
	sprite.animation = "Fly"
	tween.interpolate_property(self, "unit_offset", tween_values[0] , tween_values[1], speed ,Tween.TRANS_LINEAR, Tween.EASE_IN)    
	tween.start()

func _on_Tween_tween_completed(object, key):
	if tween_values[0] == 0:
		sprite.animation = "Still"
		var t = Timer.new()
		t.set_wait_time(rng.randf_range(wait_time_min,wait_time_max))
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		tween_values.invert()
		_start_tween()
	else:
		self.queue_free()
