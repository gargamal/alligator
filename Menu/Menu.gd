extends Control

@onready var menu_principal = $Menu_Principal
@onready var menu_option = $Menu_Option
@onready var menu_level = $Menu_Level
@onready var main_menu_pic = $Main_Menu_Pic
@onready var option_menu_pic = $Option_Menu_Pic

var difficulty:int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func clear():
	menu_option.visible = false
	menu_principal.visible = false
	menu_level.visible = false
	option_menu_pic.visible = false
	main_menu_pic.visible = false

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://level/game_level.tscn")


func _on_option_button_pressed():
	clear()
	option_menu_pic.visible = true
	menu_option.visible = true
	menu_level.visible = true


func _on_quit_button_pressed():
	get_tree().quit()


func _on_return_button_pressed():
	clear()
	main_menu_pic.visible = true
	menu_principal.visible = true



func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_easy_pressed():
	difficulty = 1


func _on_medium_pressed():
	difficulty = 2


func _on_hard_pressed():
	difficulty = 3
