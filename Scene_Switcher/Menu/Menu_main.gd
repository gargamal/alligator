extends CanvasLayer
class_name Menu_Main

signal menu_option_became_visible
signal menu_see_score_became_visible


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scene_Switcher/level/game_level.tscn")


func _on_option_button_pressed():
	visible = false
	emit_signal("menu_option_became_visible")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_see_score_pressed():
	visible = false
	emit_signal("menu_see_score_became_visible")
