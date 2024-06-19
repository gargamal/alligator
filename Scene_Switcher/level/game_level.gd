extends Node2D
class_name Game_Level

const HEIGHT :int = 1080
const WIDTH :int = 1920
const max_dist_diedbody :int = 3000

@onready var level :Node2D = $level
@onready var player = $player/player
@onready var enemy = $enemy
@onready var bullet = $bullet
@onready var drop_item = $drop_item
@onready var hud_score = $Score
@onready var game_over = $Game_Over
@onready var save_score_player = $save_score_player

@export var Menu_scene :PackedScene

var level_scene_instianble :Array =[]
var rng = RandomNumberGenerator.new()
var last_postion_level :Vector2
var id_spawn :int = 1
var points:int = 0
var nb_boss_spawned :int = 0
var game :Dictionary = {}
var nb_kill :int = 0

func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	
	game = App_Game.load_game()
	_on_add_point(0)
	game_over.visible = false
	save_score_player.visible = false
	player.set_life_max(Player.get_life_max_with_difficulty(player.life_max, game.game_level.difficulty))
	player.minimun_healing = Player.get_minimun_healing_with_difficulty(player.minimun_healing, game.game_level.difficulty)
	hud_score.init_hud(int(game.game_level.difficulty) as App_Game.Type_Difficulty)
	create_all_map()
	player.global_position = Vector2(WIDTH / 2.0, HEIGHT / 2.0)


func create_all_map():
	var matrix_map :Array = App_Main_Level_A.get_matrix_map()
	for idx in range(matrix_map.size()):
		for idy in range(matrix_map[idx].size()):
			var all_scene :Array = App_Main_Level_A.get_all_scene(matrix_map[idx][idy])
			var scene_inst :Level_A = all_scene[rng.randi_range(0, all_scene.size() - 1)].instantiate()
			level.add_child(scene_inst)
			scene_inst.global_position = Vector2(idy * WIDTH, idx * HEIGHT)
	

func _on_add_point(point_value :int):
	points += point_value
	hud_score.score = points
	if point_value > 0:
		nb_kill += 1


func _on_player_dead():
	save_score_player.score = hud_score.score
	save_score_player.difficulty = int(game.game_level.difficulty) as App_Game.Type_Difficulty
	save_score_player.visible = true


func _input(_event):
	if Input.is_action_pressed("pause_game"):
		game_over.title_name = "Pause"
		game_over.visible = true

func _on_save_score_player_player_persisted():
	game_over.title_name = "GAME OVER"
	game_over.visible = true
