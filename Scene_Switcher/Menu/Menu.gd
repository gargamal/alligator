extends Control
class_name Menu

@onready var menu_principal = $Menu_Principal
@onready var menu_option = $Menu_Option
@onready var menu_level = $Menu_Level
@onready var menu_pic = $Menu_Pic

var difficulty:int = 1

signal set_difficulty

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func clear():
	menu_pic.modulate = "ffffff"
	menu_option.visible = false
	menu_principal.visible = false
	menu_level.visible = false

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scene_Switcher/level/game_level.tscn")


func _on_option_button_pressed():
	clear()
	menu_pic.modulate = "646464"
	menu_option.visible = true
	menu_level.visible = true


func _on_quit_button_pressed():
	get_tree().quit()


func _on_return_button_pressed():
	clear()
	menu_pic.visible = true
	menu_principal.visible = true



func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_easy_pressed():
	difficulty = 1


func _on_medium_pressed():
	difficulty = 2


func _on_hard_pressed():
	difficulty = 3


func _on_tree_exited():
	emit_signal("set_difficulty")
