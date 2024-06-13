extends Node2D
class_name Level_Boss

signal spawn_boss(my_self)
signal next_map(my_self)
signal next_map_with_hole(my_self)
signal block_last_level(my_self)
signal add_point(point_value)

enum Map_Choice { BOSS_BUILDING, BOSS_FIRE, BOSS_HOLE }

@onready var city_boss_building = $Sprites/City_boss_building
@onready var city_boss_fire = $Sprites/City_boss_fire
@onready var city_boss_hole = $Sprites/City_boss_hole
@onready var top_limit = $top_border
@onready var player_border = $player_border
@onready var point_spawn = $point_spawn
@onready var city_boss_death = $Sprites/City_boss_death
@onready var blocker = $blocker
@onready var fire_particles = $fire_particles

@export var boss_scene :PackedScene
@export var world :Node2D
@export var previous :Node2D
@export var next :Node2D
@export var player :Player
@export var bullet_world :Node2D
@export var difficulty_level :App_Game.Type_Difficulty
@export var point_per_kill :int = 10


var signal_previous_level_has_sent :bool = false
var rng = RandomNumberGenerator.new()
var array_map_choice :Array = []
var map_choice :Map_Choice
var block_player_is_done :bool = false

func _ready():
	array_map_choice.append(city_boss_building)
	array_map_choice.append(city_boss_fire)
	array_map_choice.append(city_boss_hole)
	choice_map()
	spawn()


func choice_map():
	for map in array_map_choice:
		map.visible = false
	
	map_choice = rng.randi_range(0, array_map_choice.size() - 1) as Map_Choice
	array_map_choice[map_choice].visible = true
	if map_choice == Map_Choice.BOSS_HOLE:
		emit_signal("next_map_with_hole", self)
	elif map_choice == Map_Choice.BOSS_FIRE:
		top_limit.scale.y = 0.8
		player_border.scale.y = 0.8
		fire_particles.visible = true
		emit_signal("next_map", self)
	else:
		emit_signal("next_map", self)


func block_player():
	if not block_player_is_done:
		block_player_is_done = true
		blocker.collision_layer = App_Main_Level_A.COLLISION_DECOR
		blocker.collision_mask = App_Main_Level_A.COLLISION_PLAYER


func spawn():
	emit_signal("spawn_boss")
	var enemy_boss :Enemy = boss_scene.instantiate()
	enemy_boss.world = bullet_world
	enemy_boss.player = player
	enemy_boss.connect("i_am_ready_enemy", _on_enemy_is_ready)
	enemy_boss.connect("i_am_dead_boss", _on_boss_is_dead)
	world.add_child(enemy_boss)
	enemy_boss.global_position = point_spawn.global_position


func _on_enemy_is_ready(enemy :Enemy):
	enemy.is_running = true


func _on_boss_is_dead():
	top_limit.collision_layer = 0
	top_limit.collision_mask = 0
	player_border.collision_layer = 0
	player_border.collision_mask = 0
	fire_particles.visible = false
	if map_choice != Map_Choice.BOSS_HOLE:
		for map in array_map_choice:
			map.visible = false
		city_boss_death.visible = true
	emit_signal("add_point", point_per_kill)


func _on_block_last_level_body_entered(body):
	if not signal_previous_level_has_sent and body is Player:
		signal_previous_level_has_sent = true
		emit_signal("block_last_level", self)
