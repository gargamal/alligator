extends Node
class_name App_Game


const SAVE_DIRECTORY = "user://save"
const FILE_GAME_NAME = "alligator.save"
const FILE_SCORE_NAME = "score_alligator.save"
const SCORE_LINE_GAME :Dictionary = { "player_name": "", "score": 0, "difficulty": 0, "date": "YYYY-MM-DD" }
const ENCRYPT_PASSWD :String = "2024.@llig@tor!€"
const EASY_COLOR :Color = Color("5cd29a")
const MEDIUM_COLOR :Color = Color("f0a46e")
const HARD_COLOR :Color = Color("f55f52")
const SCORE_SIZE_PERSITED :int = 50


enum Type_Difficulty { EASY, MEDIUM, HARD }


func _ready():
	var dir :DirAccess = DirAccess.open("user://")
	if not dir.dir_exists(SAVE_DIRECTORY):
		dir.make_dir(SAVE_DIRECTORY)
	audio_init()
	cursor_init()


static func save_game(game :Dictionary) -> void:
	var path_name :String = SAVE_DIRECTORY + "/" + FILE_GAME_NAME
	var file_save :FileAccess = FileAccess.open_encrypted_with_pass(path_name, FileAccess.WRITE, ENCRYPT_PASSWD)
	if file_save:
		file_save.store_string(JSON.stringify(game))
		file_save.close()


func audio_init() -> void:
	var game :Dictionary = App_Game.load_game()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), game.params.ui_master_sound)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), game.params.ui_music_sound)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), game.params.ui_sfx_sound)


func cursor_init() -> void:
	var cursor_arrow :Texture = load("res://Scene_Switcher/Menu/asset/mouse/mouse_arrow.png")
	Input.set_custom_mouse_cursor(cursor_arrow, Input.CURSOR_ARROW, Vector2(8, 14))


static func load_game() -> Dictionary:
	var game :Dictionary
	var path_name = SAVE_DIRECTORY + "/" + FILE_GAME_NAME
	
	var file_open :FileAccess = FileAccess.open_encrypted_with_pass(path_name, FileAccess.READ, ENCRYPT_PASSWD)
	if file_open:
		game = JSON.parse_string(file_open.get_as_text())
		file_open.close()
	else:
		game = { 
			"params": {
				"ui_master_sound": 0.0,
				"ui_music_sound": 0.0,
				"ui_sfx_sound":  0.0,
				},
			"game_level" :{
				"difficulty": 1
			}
		}
	
	return game


static func persist_score_player(player_name :String, score :int, difficulty :Type_Difficulty) -> void:
	var score_game :Array = []
	var path_name = SAVE_DIRECTORY + "/" + FILE_SCORE_NAME
	
	var file_open :FileAccess = FileAccess.open_encrypted_with_pass(path_name, FileAccess.READ, ENCRYPT_PASSWD)
	if file_open:
		score_game = JSON.parse_string(file_open.get_as_text())
		file_open.close()
	
	var new_line :Dictionary = SCORE_LINE_GAME.duplicate()
	new_line.player_name = player_name
	new_line.score = score
	new_line.difficulty = difficulty
	new_line.date = Time.get_date_string_from_system(true)
	score_game.append(new_line)
	
	score_game.sort_custom(sort_score_game)
	
	while score_game.size() > SCORE_SIZE_PERSITED:
		score_game.remove_at(score_game.size() - 1)
	
	var file_save :FileAccess = FileAccess.open_encrypted_with_pass(path_name, FileAccess.WRITE, ENCRYPT_PASSWD)
	if file_save:
		file_save.store_string(JSON.stringify(score_game))
		file_save.close()


static func get_all_score() -> Array:
	var score_game :Array = []
	var path_name = SAVE_DIRECTORY + "/" + FILE_SCORE_NAME
	var file_open :FileAccess = FileAccess.open_encrypted_with_pass(path_name, FileAccess.READ, ENCRYPT_PASSWD)
	if file_open:
		score_game = JSON.parse_string(file_open.get_as_text())
		file_open.close()
	return score_game


static func sort_score_game(a, b):
	if a.score > b.score: return true
	elif a.score == b.score and a.difficulty > b.difficulty: return true
	elif a.score == b.score and a.difficulty == b.difficulty and \
		Time.get_unix_time_from_datetime_string(a.date) < Time.get_unix_time_from_datetime_string(b.date):
		return true
	return false
