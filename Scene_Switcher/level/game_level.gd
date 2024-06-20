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
@onready var hud_extract_map = $hud_extract_map


var level_scene_instianble :Array =[]
var rng = RandomNumberGenerator.new()
var last_postion_level :Vector2
var id_spawn :int = 1
var points:int = 0
var nb_boss_spawned :int = 0
var game :Dictionary = {}
var nb_kill :int = 0
var map_active :Level_A
var map_spawn :Dictionary = {}
var matrix_of_scene :Array = []
var extract_area_idx :Vector2i

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
	player.global_position.y = HEIGHT * matrix_of_scene.size() - HEIGHT / 2.0
	player.global_position.x = WIDTH * rng.randi_range(1, matrix_of_scene[0].size()) - WIDTH / 2.0
	
	extract_area_idx.x = rng.randi_range(0, matrix_of_scene.size() - 1)
	extract_area_idx.y = 0
	hud_extract_map.extract_point = Vector2(extract_area_idx.x * WIDTH + Level_A.EXTRACT_AREA_POSITION.x, Level_A.EXTRACT_AREA_POSITION.y)
	
	manage_map_spawn(false)


func _process(_delta):
	if map_active:
		if player.global_position.x < map_active.global_position.x or player.global_position.y < map_active.global_position.y or \
			player.global_position.x > map_active.global_position.x + WIDTH or player.global_position.y > map_active.global_position.y + HEIGHT:
			manage_map_spawn()


func manage_map_spawn(with_spawn_enemy :bool = true):
	@warning_ignore("integer_division")
	var idx :int = int(int(player.global_position.x) / WIDTH)
	@warning_ignore("integer_division")
	var idy :int = int(int(player.global_position.y) / HEIGHT)
	
	for coord_x in range(-1, 2):
		for coord_y in range(-1, 2):
			if coord_x == 0 and coord_y == 0:
				spawn_map(idx + coord_x, idy + coord_y, with_spawn_enemy)
			else:
				spawn_map(idx + coord_x, idy + coord_y)
	
	for coord_x in range(-2, 3):
		for coord_y in range(-2, 3):
			if coord_x in [-1, 0 , 1] and coord_y in [-1, 0 , 1]:
				continue
			de_spawn_map(idx + coord_x, idy + coord_y)
	
	var key_map :String = get_key_map(idx, idy, Vector2(idx * WIDTH, idy * HEIGHT))
	map_active = map_spawn.get(key_map)


# if null kel return empty string
func get_key_map(idx :int, idy :int, origin_point :Vector2) -> String:
	if idx < 0 or idx > matrix_of_scene[0].size() - 1 or idy < 0 or idy > matrix_of_scene.size() - 1:
		return ""
	return "map_" + str(origin_point.x) + "x" + str(origin_point.y)


func de_spawn_map(idx :int, idy :int):
	var origin_point :Vector2 = Vector2(idx * WIDTH, idy * HEIGHT)
	var key_map :String = get_key_map(idx, idy, origin_point)
	if key_map == "": return
	
	var map_spawned :Level_A = map_spawn.get(key_map)
	if map_spawned != null:
		map_spawn.erase(key_map)
		map_spawned.free_map(map_active, player)


# return true if spawn or false is not spawn
func spawn_map(idx :int, idy :int, with_spawn_enemy: bool = true) -> bool:
	var origin_point :Vector2 = Vector2(idx * WIDTH, idy * HEIGHT)
	var key_map :String = get_key_map(idx, idy, origin_point)
	if key_map == "": return false
	
	var map_spawned :Level_A = map_spawn.get(key_map)
	if map_spawned == null:
		var scene_inst :Level_A = matrix_of_scene[idy][idx].instantiate()
		level.add_child(scene_inst)
		scene_inst.global_position = origin_point
		scene_inst.name = key_map
		scene_inst.connect("add_point", _on_add_point)
		if idx == extract_area_idx.x and idy == extract_area_idx.y:
			scene_inst.add_extract_area()
			scene_inst.connect("end_game", _on_end_game)
		if with_spawn_enemy:
			scene_inst.spawn_enemies(player, enemy, drop_item, bullet, game.game_level.difficulty as App_Game.Type_Difficulty)
		map_spawn[key_map] = scene_inst
	
	return true


func _on_end_game():
	_on_player_i_am_dead(null)


func create_all_map():
	var matrix_map :Array = App_Main_Level_A.get_matrix_map()
	for idx in range(matrix_map.size()):
		var line_of_scene :Array = []
		for idy in range(matrix_map[idx].size()):
			var all_scene :Array = App_Main_Level_A.get_all_scene(matrix_map[idx][idy])
			line_of_scene.append(all_scene[rng.randi_range(0, all_scene.size() - 1)])
		matrix_of_scene.append(line_of_scene)


func _on_add_point(point_value :int):
	points += point_value
	hud_score.score = points
	if point_value > 0:
		nb_kill += 1


func _input(_event):
	if Input.is_action_pressed("pause_game"):
		game_over.title_name = "Pause"
		game_over.visible = true


func _on_save_score_player_player_persisted():
	game_over.title_name = "GAME OVER"
	game_over.visible = true


func _on_player_i_am_dead(_my_self):
	save_score_player.score = hud_score.score
	save_score_player.difficulty = int(game.game_level.difficulty) as App_Game.Type_Difficulty
	save_score_player.visible = true
