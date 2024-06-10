extends Node2D
class_name Impact_sound

signal finished

var idx_impact_sound : int = 0
var rng = RandomNumberGenerator.new()

func _on_impact():
	idx_impact_sound = rng.randi_range(0,get_child_count()-1)
	get_child(idx_impact_sound).play()


func _on_bullet_impact_finished():
	emit_signal("finished")
