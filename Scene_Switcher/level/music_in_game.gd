extends Node
class_name Music_In_Game

var idx_child_music :int = 0

func _ready():
	await get_tree().create_timer(0.2).timeout
	get_child(idx_child_music).play()


func _on_music_finished():
	idx_child_music += 1
	idx_child_music = idx_child_music if idx_child_music < get_child_count() else 0
	
	await get_tree().create_timer(0.5).timeout
	get_child(idx_child_music).play()
