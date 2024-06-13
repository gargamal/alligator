extends Node2D
class_name Menu

@onready var menu_main = $Menu_Main
@onready var menu_option = $Menu_Option
@onready var menu_see_score = $menu_see_score


func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	menu_main.visible = true
	menu_option.visible = false
	menu_see_score.visible = false


func _on_menu_main_menu_option_became_visible():
	menu_option.visible = true


func _on_menu_option_menu_main_became_visible():
	menu_main.visible = true


func _on_menu_see_score_menu_main_became_visible():
	menu_main.visible = true


func _on_menu_main_menu_see_score_became_visible():
	menu_see_score.visible = true
