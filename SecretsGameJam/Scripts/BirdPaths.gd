extends Node2D

var bird = preload("res://scenes/Bird.tscn")
var rng = RandomNumberGenerator.new()
export var chance = 10
var paths = []

func _ready():
	for child in self.get_children():
		paths.append(child)

func _physics_process(_delta):
	var rng_num = rng.randi_range(0, 10000)
	var rng_path = rng.randi_range(0, paths.size()-1)
	if rng_num <= chance:
		if paths[rng_path].get_children() == []:
			var bird_spawn = bird.instance()
			print(paths[rng_path].get_curve().get_baked_length()/20)
			bird_spawn.speed = paths[rng_path].get_curve().get_baked_length()/20
			paths[rng_path].add_child(bird_spawn)
		
