extends Control
class_name Menu

const ATTENUATION_DB :float = 40.0

@onready var menu_principal = $Menu_Principal
@onready var menu_option = $Menu_Option
@onready var menu_level = $Menu_Level
@onready var menu_pic = $Menu_Pic
@onready var h_slider = $Menu_Option/HSlider


var game :Dictionary

func _ready():
	game = App_Game.load_game()
	h_slider.value = db_to_linear(game.params.ui_master_sound + ATTENUATION_DB)


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
	var volume :float = (linear_to_db(value) if value > 0 else -10.0) - ATTENUATION_DB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	game.params.ui_master_sound = volume
	App_Game.save_game(game)

func _on_easy_pressed():
	game.game_level.difficulty = App_Game.Type_Difficulty.EASY
	App_Game.save_game(game)

func _on_medium_pressed():
	game.game_level.difficulty = App_Game.Type_Difficulty.MEDIUM
	App_Game.save_game(game)

func _on_hard_pressed():
	game.game_level.difficulty = App_Game.Type_Difficulty.HARD
	App_Game.save_game(game)
