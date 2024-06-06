extends Node2D
class_name Game_Level

const HEIGHT :int = 1080
const max_dist_diedbody :int = 3000
const KILL_LIMIT_TO_CALL_BOSS :int = 5

@onready var level :Node2D = $level
@onready var player = $player/player
@onready var level_a_2 = $level/level_a2
@onready var level_a_1 = $level/level_a1
@onready var level_a_0 = $level/level_a0
@onready var enemy = $enemy
@onready var bullet = $bullet
@onready var drop_item = $drop_item
@onready var score_label = $Score/Score/Score_Label
@onready var game_over = $Game_Over/Game_Over
@onready var game_over_label = $Game_Over/Game_Over/Game_Over_Label

@export var level_scene_1 :PackedScene
@export var level_scene_2 :PackedScene
@export var level_scene_3 :PackedScene
@export var level_scene_4 :PackedScene
@export var level_scene_5 :PackedScene
@export var level_scene_6 :PackedScene
@export var level_scene_7 :PackedScene
@export var level_scene_8 :PackedScene
@export var level_scene_9 :PackedScene
@export var level_scene_after_boss :PackedScene
@export var level_scene_boss :PackedScene
@export var item_scene : PackedScene
@export var max_enemy :int = 4
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
	for child_level in level.get_children():
		child_level.connect("spawn_new_level", _on_spawn_new_level)
		child_level.connect("block_last_level", _on_block_last_level)
		child_level.name = "Level_" + str(id_spawn)
		id_spawn += 1
	last_postion_level = level_a_2.position
	
	if level_scene_1:
		level_scene_instianble.append(level_scene_1)
	if level_scene_2:
		level_scene_instianble.append(level_scene_2)
	if level_scene_3:
		level_scene_instianble.append(level_scene_3)
	if level_scene_4:
		level_scene_instianble.append(level_scene_4)
	if level_scene_5:
		level_scene_instianble.append(level_scene_5)
	if level_scene_6:
		level_scene_instianble.append(level_scene_6)
	if level_scene_7:
		level_scene_instianble.append(level_scene_7)
	if level_scene_8:
		level_scene_instianble.append(level_scene_8)
	if level_scene_9:
		level_scene_instianble.append(level_scene_9)
		
	level_a_0.signal_next_level_has_sent = true
	level_a_0.signal_previous_level_has_sent = true
	level_a_0.block_player()
	
	game = App_Game.load_game()
	_on_add_point(0)

func _on_spawn_new_level(actual_level :Node2D):
	var level_scene :PackedScene = level_scene_instianble[rng.randi_range(0, level_scene_instianble.size() - 1)]
	spawn_new_level(actual_level, level_scene.instantiate())

func spawn_new_After_Boss(boss_level :Level_Boss, level_inst :App_Main_Level_A):
	spawn_new_level(boss_level, level_inst, true)

func spawn_new_level(actual_level :Node2D, level_inst :App_Main_Level_A, is_boss_level :bool = false):
	level.call_deferred("add_child", level_inst)
	
	level_inst.z_index = -1
	level_inst.position.y = last_postion_level.y - HEIGHT
	last_postion_level = level_inst.position
	level_inst.world = enemy
	level_inst.world_drop_item = drop_item
	
	level_inst.connect("spawn_new_level", _on_spawn_new_level)
	level_inst.connect("block_last_level", _on_block_last_level)
	level_inst.connect("i_am_ready_level", _on_level_is_ready)
	level_inst.connect("add_point", _on_add_point)
	level_inst.connect("next_level_is_boss", _on_spawn_boss_level)
	
	level_inst.name = "Level_" + str(id_spawn)
	
	if is_boss_level:
		manage_next_previous_boss(level_inst, actual_level)
	else:
		manage_next_previous(level_inst, actual_level)
	
	id_spawn += 1


func manage_next_previous_boss(level_inst :Node2D, boss_level :Level_Boss):
	boss_level.next = level_inst
	level_inst.previous = boss_level

func manage_next_previous(level_inst :Node2D, actual_level :Node2D):
	level_inst.previous = actual_level.next
	level_inst.previous.next = level_inst
	actual_level.next.next = level_inst


func _on_level_is_ready(p_level :App_Main_Level_A):
	var number_enemy_spawnable :int = max_enemy - enemy.get_children().filter(func(child): return child is Enemy and child.is_alive).size()
	
	if number_enemy_spawnable > 0:
		p_level.spawn(rng.randi_range(1, number_enemy_spawnable), player, bullet, game.game_level.difficulty)

func free_level():
	if level.get_child_count() > 4:
		level.get_child(0).queue_free()

func _on_block_last_level(actual_level :Node2D):
	if actual_level.previous:
		actual_level.previous.block_player()
		free_level()


func _on_clear_timeout():
	for enemy_body in enemy.get_children():
		if enemy_body.global_position.y > player.global_position.y + max_dist_diedbody :
			enemy_body.queue_free()


func _on_add_point(point_value :int):
	points += point_value
	score_label.text = "Score : " + str("%05d" % points)
	if point_value > 0:
		nb_kill += 1
		if nb_kill % KILL_LIMIT_TO_CALL_BOSS == 0:
			for child_level in level.get_children():
				if "boss_can_spawn" in child_level:
					child_level.boss_can_spawn = true

func _on_player_dead():
	game_over_label.text = "GAME OVER"
	game_over.show()
	get_tree().paused = true


func _on_button_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	player.set_life(player.life_max)


func _on_button_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene_Switcher/Menu/Menu.tscn")

func _input(_event):
	if Input.is_action_pressed("pause_game"):
		game_over_label.text = "Pause"
		game_over.show()
		get_tree().paused = true


func _on_button_resume_pressed():
	get_tree().paused = false
	game_over.hide()

func _on_spawn_boss_level(actual_level :Node2D):
	if actual_level.next is Level_Boss or actual_level is Level_Boss:
		return
	
	var level_boss :Level_Boss = level_scene_boss.instantiate()
	level_boss.z_index = -1
	level_boss.position.y = last_postion_level.y - HEIGHT
	last_postion_level = level_boss.position
	
	level_boss.previous = actual_level.next
	level_boss.previous.next = level_boss
	
	level_boss.world = enemy
	level_boss.player = player
	level_boss.bullet_world = bullet
	level_boss.difficulty_level = game.game_level.difficulty
	level_boss.connect("next_map_with_hole", _on_next_map_with_hole)
	level_boss.connect("next_map", _on_next_map)
	level_boss.connect("add_point", _on_add_point)
	level_boss.connect("block_last_level", _on_block_last_level)
	
	level.call_deferred("add_child", level_boss)


func _on_next_map_with_hole(level_boss :Level_Boss):
	spawn_new_After_Boss(level_boss, level_scene_after_boss.instantiate())
	var level_scene :PackedScene = level_scene_instianble[rng.randi_range(0, level_scene_instianble.size() - 1)]
	spawn_new_level(level_boss, level_scene.instantiate())


func _on_next_map(level_boss :Level_Boss):
	var normal_scene_after_boss :PackedScene = level_scene_instianble[rng.randi_range(0, level_scene_instianble.size() - 1)]
	spawn_new_After_Boss(level_boss, normal_scene_after_boss.instantiate())
	
	var level_scene :PackedScene = level_scene_instianble[rng.randi_range(0, level_scene_instianble.size() - 1)]
	spawn_new_level(level_boss, level_scene.instantiate())
