extends CanvasLayer
class_name Menu_Option

const ATTENUATION_DB :float = 40.0
const FOCUS_COLOR_EASY :Color = Color("5cd29a")
const FOCUS_COLOR_MEDIUM :Color = Color("f0a46e")
const FOCUS_COLOR_HARD :Color = Color("f55f52")
const NO_FOCUS_COLOR :Color = Color("ffffff")

signal menu_main_became_visible


@onready var master_volume = $main_cont/columns/column_volume/master_volume
@onready var music_volume = $main_cont/columns/column_volume/music_volume
@onready var sfx_volume = $main_cont/columns/column_volume/sfx_volume
@onready var btn_easy = $main_cont/columns/column_game_level/Easy
@onready var btn_medium = $main_cont/columns/column_game_level/Medium
@onready var btn_hard = $main_cont/columns/column_game_level/Hard


var game :Dictionary


func _ready():
	game = App_Game.load_game()
	master_volume.value = db_to_linear(game.params.ui_master_sound + ATTENUATION_DB)
	music_volume.value = db_to_linear(game.params.ui_music_sound + ATTENUATION_DB)
	sfx_volume.value = db_to_linear(game.params.ui_sfx_sound + ATTENUATION_DB)
	
	var difficulty :App_Game.Type_Difficulty = int(game.game_level.difficulty) as App_Game.Type_Difficulty
	match difficulty:
		App_Game.Type_Difficulty.EASY: change_clor_text_button(btn_easy, FOCUS_COLOR_EASY)
		App_Game.Type_Difficulty.MEDIUM: change_clor_text_button(btn_medium, FOCUS_COLOR_MEDIUM)
		App_Game.Type_Difficulty.HARD: change_clor_text_button(btn_hard, FOCUS_COLOR_HARD)


func change_clor_text_button(btn :Button, color :Color):
	btn.set("theme_override_colors/font_color", color)
	btn.set("theme_override_colors/font_focus_color", color)
	btn.set("theme_override_colors/font_hover_color", color)


func _on_master_volume_value_changed(value):
	var volume :float = (linear_to_db(value) if value > 0 else -10.0) - ATTENUATION_DB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	game.params.ui_master_sound = volume
	App_Game.save_game(game)


func _on_music_volume_value_changed(value):
	var volume :float = (linear_to_db(value) if value > 0 else -10.0) - ATTENUATION_DB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume)
	game.params.ui_music_sound = volume
	App_Game.save_game(game)


func _on_sfx_volume_value_changed(value):
	var volume :float = (linear_to_db(value) if value > 0 else -10.0) - ATTENUATION_DB
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), volume)
	game.params.ui_sfx_sound = volume
	App_Game.save_game(game)


func no_focus_button():
	change_clor_text_button(btn_easy, NO_FOCUS_COLOR)
	change_clor_text_button(btn_medium, NO_FOCUS_COLOR)
	change_clor_text_button(btn_hard, NO_FOCUS_COLOR)


func _on_easy_pressed():
	game.game_level.difficulty = App_Game.Type_Difficulty.EASY
	no_focus_button()
	change_clor_text_button(btn_easy, FOCUS_COLOR_EASY)
	App_Game.save_game(game)


func _on_medium_pressed():
	game.game_level.difficulty = App_Game.Type_Difficulty.MEDIUM
	no_focus_button()
	change_clor_text_button(btn_medium, FOCUS_COLOR_MEDIUM)
	App_Game.save_game(game)


func _on_hard_pressed():
	game.game_level.difficulty = App_Game.Type_Difficulty.HARD
	no_focus_button()
	change_clor_text_button(btn_hard, FOCUS_COLOR_HARD)
	App_Game.save_game(game)


func _on_return_button_pressed():
	visible = false
	emit_signal("menu_main_became_visible")
