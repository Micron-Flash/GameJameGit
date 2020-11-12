extends Light2D

onready var light = self 
onready var tween = $Tween
onready var tween_values = [0.75, 1]
var rng = RandomNumberGenerator.new()

func _ready():
	_start_tween()

func _start_tween():
	var rng_speed = rng.randf_range(0.75, 2.5)
	tween.interpolate_property(self, "energy", tween_values[0] , tween_values[1], rng_speed ,Tween.TRANS_BOUNCE, Tween.EASE_IN)    
	tween.start()


func _on_Tween_tween_completed(_object, _key):
	tween_values.invert()
	_start_tween()
