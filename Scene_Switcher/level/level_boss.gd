extends Node2D
class_name Level_Boss

signal spawn_boss(my_self)
signal next_map(my_self)
signal next_map_with_hole(my_self)

enum Map_Choice { BOSS_BUILDING, BOSS_FIRE, BOSS_HOLE }

@onready var city_boss_building = $Sprites/City_boss_building
@onready var city_boss_fire = $Sprites/City_boss_fire
@onready var city_boss_hole = $Sprites/City_boss_hole
@onready var top_limit = $top_border/limit
@onready var point_spawn = $point_spawn
@onready var city_boss_death = $Sprites/City_boss_death

@export var boss_scene :PackedScene
@export var world :Node2D
@export var previous :Node2D
@export var next :Node2D
@export var player :Player
@export var bullet_world :Node2D
@export var difficulty_level :App_Game.Type_Difficulty
@export var points: int = 0


var rng = RandomNumberGenerator.new()
var array_map_choice :Array = []
var map_choice :Map_Choice

func _ready():
	array_map_choice.append(city_boss_building)
	array_map_choice.append(city_boss_fire)
	array_map_choice.append(city_boss_hole)
	star_map()
	spawn()


func star_map():
	for map in array_map_choice:
		map.visible = false
	
	map_choice = rng.randi_range(0, array_map_choice.size() - 1) as Map_Choice
	array_map_choice[map_choice].visible = true


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
	for map in array_map_choice:
		map.visible = false
	city_boss_death.visible = true
	if map_choice == Map_Choice.BOSS_HOLE:
		emit_signal("next_map_with_hole", self)
	else:
		emit_signal("next_map", self)
