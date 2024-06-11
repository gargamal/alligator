extends Node2D
class_name Fire_Weapon

var rng = RandomNumberGenerator.new()

func fire():
	get_child(rng.randi_range(0,get_child_count()-1)).play()
