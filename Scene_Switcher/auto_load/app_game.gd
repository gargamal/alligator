extends Node
class_name App_Game


const SAVE_DIRECTORY = "user://save"
const GAME_NAME = "alligator.save"
const ENCRYPT_PASSWD :String = "2024.@llig@tor!€"


enum Type_Difficulty { EASY, MEDIUM, HARD }


func _ready():
	var dir :DirAccess = DirAccess.open("user://")
	if not dir.dir_exists(SAVE_DIRECTORY):
		dir.make_dir(SAVE_DIRECTORY)
	audio_init()


static func save_game(game :Dictionary) -> void:
	var path_name :String = SAVE_DIRECTORY + "/" + GAME_NAME
	var file_save :FileAccess = FileAccess.open_encrypted_with_pass(path_name, FileAccess.WRITE, ENCRYPT_PASSWD)
	if file_save:
		file_save.store_string(JSON.stringify(game))
		file_save.close()


func audio_init() -> void:
	var game :Dictionary = App_Game.load_game()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), game.params.ui_master_sound)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), game.params.ui_music_sound)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), game.params.ui_sfx_sound)


static func load_game() -> Dictionary:
	var game :Dictionary
	var path_name = SAVE_DIRECTORY + "/" + GAME_NAME
	
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
