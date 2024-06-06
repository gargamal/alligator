extends Node2D
class_name Menu

@onready var menu_main = $Menu_Main
@onready var menu_option = $Menu_Option


func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	$Menu_Main.visible = true
	$Menu_Option.visible = false


func _on_menu_main_menu_option_became_visible():
	menu_option.visible = true


func _on_menu_option_menu_main_became_visible():
	menu_main.visible = true
