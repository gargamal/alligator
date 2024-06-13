extends Node2D
class_name App_Main_Level_A

const WAIT_TIME_MSEC :int = 100
const COLLISION_PLAYER :int = 1
const COLLISION_DECOR :int = 16

enum Type_City { CITY_1_BASIC, CITY_1_LEFT, CITY_1_RIGHT, CITY_1_LEFT_AND_RIGHT, CITY_2_BASIC, CITY_2_LEFT, CITY_2_RIGHT, CITY_2_LEFT_AND_RIGHT }

signal spawn_new_level(my_self)
signal next_level_is_boss(my_self)
signal block_last_level(my_self)
signal i_am_ready_level(my_self)
signal add_point(point_value)

@export var signal_next_level_has_sent :bool = false
@export var signal_previous_level_has_sent :bool = false
@export var block_player_is_done :bool = false
@export var block_boss_is_done :bool = false
@export var previous :Node2D
@export var next :Node2D
@export var world :Node2D
@export var world_drop_item :Node2D
@export var assault_tank_scene :PackedScene
@export var helicopter_scene :PackedScene
@export var jeep_scene :PackedScene
@export var artillery_scene :PackedScene
@export var item_drop_scene :PackedScene
@export_range(0.0, 1.0) var drop_chance :float = 0.2
@export var point_per_kill :int = 1

var blocker :StaticBody2D
var spawn_point :Node2D

var array_of_spawn :Array = []
var scene_of_spawn :Array = []
var sprite_of_map :Array = []
var rng = RandomNumberGenerator.new()
var boss_can_spawn :bool = false

func spawn(number_of_spawn :int, player :Player, bullet_world :Node2D, difficulty_level :App_Game.Type_Difficulty):
	var work_arr :Array = array_of_spawn.duplicate()
	
	for idx in range(number_of_spawn):
		var index :int = rng.randi_range(0, work_arr.size() - 1)
		var point_spawn :Marker2D = work_arr[index]
		var enemy :Enemy = scene_of_spawn[rng.randi_range(0, scene_of_spawn.size() - 1)].instantiate()
		enemy.world = bullet_world
		enemy.player = player
		enemy.life_max = get_life_enemy(enemy.life_max, difficulty_level)
		enemy.connect("i_am_ready_enemy", _on_enemy_is_ready)
		enemy.connect("i_am_death", _on_enemy_is_death)
		world.add_child(enemy)
		enemy.global_position = point_spawn.global_position
		work_arr.remove_at(index)

func get_life_enemy(life_max :float, difficulty_level :App_Game.Type_Difficulty) -> float:
	match difficulty_level:
		App_Game.Type_Difficulty.EASY: return life_max / 2.0 + 0.5
		App_Game.Type_Difficulty.HARD: return life_max * 1.5 + 0.5
		_: return life_max

func _on_enemy_is_death(enemy :Enemy):
	if rng.randf_range(0.0, 1.0) <= drop_chance:
		var item_drop :ItemBox = item_drop_scene.instantiate()
		world_drop_item.add_child(item_drop)
		item_drop.global_position = enemy.global_position
	emit_signal("add_point", point_per_kill)

func _on_enemy_is_ready(enemy :Enemy):
	enemy.is_running = true

func _on_other_level_body_entered(body):
	if not signal_next_level_has_sent and body is Player:
		signal_next_level_has_sent = true
		if boss_can_spawn:
			emit_signal("next_level_is_boss", self)
			boss_can_spawn = false
		else:
			emit_signal("spawn_new_level", self)

func _on_block_last_level_body_entered(body):
	if not signal_previous_level_has_sent and body is Player:
		signal_previous_level_has_sent = true
		emit_signal("block_last_level", self)

func block_player():
	if not block_player_is_done:
		block_player_is_done = true
		blocker.collision_layer = COLLISION_DECOR
		blocker.collision_mask = COLLISION_PLAYER
	

func _on_static_body_2d_other_body_entered(body):
	if body is Bullet:
		body.queue_free()
