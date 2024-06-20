extends Node2D
class_name Level_A


const EXTRACT_AREA_POSITION :Vector2 = Vector2(960.0, 650.0)


signal add_point(point_value)
signal end_game


@onready var spawn_point = $spawn_point

@export var item_scene : PackedScene
@export var max_enemy :int = 4
@export var extract_area_scene : PackedScene = load("res://Scene_Switcher/level/extract_area.tscn")
@export var assault_tank_scene :PackedScene = load("res://Scene_Switcher/enemy/assault_tank.tscn")
@export var helicopter_scene :PackedScene = load("res://Scene_Switcher/enemy/helicopter.tscn")
@export var jeep_scene :PackedScene = load("res://Scene_Switcher/enemy/jeep.tscn")
@export var artillery_scene :PackedScene = load("res://Scene_Switcher/enemy/artillery.tscn")
@export var kamikaze_scene :PackedScene = load("res://Scene_Switcher/enemy/Kamikaze.tscn")
@export var item_drop_scene :PackedScene = load("res://Scene_Switcher/enemy/Drop/item_drop.tscn")
@export_range(0.0, 1.0) var drop_chance :float = 0.2
@export var point_per_kill :int = 1


var world_drop_item :Node2D
var array_of_spawn :Array = []
var scene_of_spawn :Array = []
var array_of_enemy :Array = []
var rng = RandomNumberGenerator.new()


func _ready():
	if spawn_point:
		array_of_spawn = spawn_point.get_children()
		
		if array_of_spawn.size() > 0:
			#if assault_tank_scene:
				#scene_of_spawn.append(assault_tank_scene)
			#if helicopter_scene:
				#scene_of_spawn.append(helicopter_scene)
			#if jeep_scene:
				#scene_of_spawn.append(jeep_scene)
			#if artillery_scene:
				#scene_of_spawn.append(artillery_scene)
			if kamikaze_scene:
				scene_of_spawn.append(kamikaze_scene)


func add_extract_area():
	var extract_area = extract_area_scene.instantiate()
	add_child(extract_area)
	extract_area.position = EXTRACT_AREA_POSITION
	extract_area.connect("body_entered", _on_body_entered_in_extract_area)


func _on_body_entered_in_extract_area(body: Node2D):
	if body is Player:
		emit_signal("end_game")


func spawn_enemies(player :Player, world :Node2D, bullet_world :Node2D, p_world_drop_item :Node2D, difficulty_level :App_Game.Type_Difficulty):
	if array_of_spawn .size() == 0:
		return
	
	var work_arr :Array = array_of_spawn.duplicate()
	var nb_spawn :int = array_of_spawn.size()
	nb_spawn = nb_spawn if nb_spawn < max_enemy else max_enemy
	var number_of_spawn :int = rng.randi_range(1, nb_spawn)
	
	world_drop_item = p_world_drop_item
	
	for idx in range(number_of_spawn):
		var index :int = rng.randi_range(0, work_arr.size() - 1)
		var point_spawn :Marker2D = work_arr[index]
		var enemy :App_Enemy = scene_of_spawn[rng.randi_range(0, scene_of_spawn.size() - 1)].instantiate()
		enemy.world = bullet_world
		enemy.player = player
		enemy.life_max = get_life_enemy(enemy.life_max, difficulty_level)
		enemy.connect("i_am_ready_enemy", _on_enemy_is_ready)
		enemy.connect("i_am_death", _on_enemy_is_death)
		world.add_child(enemy)
		array_of_enemy.append(enemy)
		enemy.global_position = point_spawn.global_position
		work_arr.remove_at(index)


func free_map(map_active :Level_A, player :Player):
	while array_of_enemy.size() > 0:
		var distance_player = (player.global_position - array_of_enemy[0].global_position).length()
		if array_of_enemy[0].is_alive and distance_player < App_Enemy.LENGHT_FOLLOW_PLAYER:
			map_active.array_of_enemy.append(array_of_enemy[0])
		else:
			array_of_enemy[0].queue_free()
		array_of_enemy.remove_at(0)
	queue_free()


func _on_enemy_is_death(enemy :App_Enemy):
	if rng.randf_range(0.0, 1.0) <= drop_chance:
		var item_drop :ItemBox = item_drop_scene.instantiate()
		world_drop_item.call_deferred("add_child", item_drop)
		item_drop.global_position = enemy.global_position
	emit_signal("add_point", point_per_kill)


func _on_enemy_is_ready(enemy :App_Enemy):
	enemy.is_running = true


func get_life_enemy(life_max :float, difficulty_level :App_Game.Type_Difficulty) -> float:
	match difficulty_level:
		App_Game.Type_Difficulty.EASY: return life_max / 2.0 + 0.5
		App_Game.Type_Difficulty.HARD: return life_max * 1.5 + 0.5
		_: return life_max
