extends Node2D
class_name Level

const WAIT_TIME_MSEC :int = 100
const COLLISION_PLAYER :int = 1
const COLLISION_DECOR :int = 16

@onready var blocker = $blocker
@onready var spawn_point = $spawn_point
@onready var city_1_basic = $Sprites/city_1_basic
@onready var city_2_basic = $Sprites/city_2_basic
@onready var city_1_left = $Sprites/city_1_left
@onready var city_1_right = $Sprites/city_1_right
@onready var city_1_left_and_right = $Sprites/city_1_left_and_right
@onready var city_2_left = $Sprites/city_2_left
@onready var city_2_right = $Sprites/city_2_right
@onready var city_2_left_and_right = $Sprites/city_2_left_and_right


signal spawn_new_level(my_self)
signal block_last_level(my_self)
signal i_am_ready_level(my_self)
signal add_point(my_self)

@export var signal_next_level_has_sent :bool = false
@export var signal_previous_level_has_sent :bool = false
@export var block_player_is_done :bool = false
@export var previous :Level
@export var next :Level
@export var world :Node2D
@export var world_drop_item :Node2D
@export var assault_tank_scene :PackedScene
@export var helicopter_scene :PackedScene
@export var jeep_scene :PackedScene
@export var artillery_scene :PackedScene
@export var item_drop_scene :PackedScene
@export_range(0.0, 1.0) var drop_chance :float = 0.2

var array_of_spawn :Array = []
var scene_of_spawn :Array = []
var rng = RandomNumberGenerator.new()

func _ready():
	array_of_spawn = spawn_point.get_children()
	if assault_tank_scene:
		scene_of_spawn.append(assault_tank_scene)
	if helicopter_scene:
		scene_of_spawn.append(helicopter_scene)
	if jeep_scene:
		scene_of_spawn.append(jeep_scene)
	if artillery_scene:
		scene_of_spawn.append(artillery_scene)
	
	var map:int = rng.randi_range(1, 8)
	
	match map:
		1:
			clear_city()
			city_1_basic.visible = true
		2:
			clear_city()
			city_1_left.visible = true
		3:
			clear_city()
			city_1_left_and_right.visible = true
		4:
			clear_city()
			city_1_right.visible = true
		5:
			clear_city()
			city_2_basic.visible = true
		6:
			clear_city()
			city_2_left.visible = true
		7:
			clear_city()
			city_2_left_and_right.visible = true
		8:
			clear_city()
			city_2_right.visible = true
	
	emit_signal("i_am_ready_level", self)

func clear_city():
	city_1_basic.visible = false
	city_1_left.visible = false
	city_1_left_and_right.visible = false
	city_1_right.visible = false
	city_2_basic.visible = false
	city_2_left.visible = false
	city_2_left_and_right.visible = false
	city_2_right.visible = false

func spawn(number_of_spawn :int, player :Player, bullet_world :Node2D):
	var work_arr :Array = array_of_spawn.duplicate()
	
	for idx in range(number_of_spawn):
		var index :int = rng.randi_range(0, work_arr.size() - 1)
		var point_spawn :Marker2D = work_arr[index]
		var enemy :Enemy = scene_of_spawn[rng.randi_range(0, scene_of_spawn.size() - 1)].instantiate()
		enemy.world = bullet_world
		enemy.player = player
		enemy.connect("i_am_ready_enemy", _on_enemy_is_ready)
		enemy.connect("i_am_death", _on_enemy_is_death)
		world.add_child(enemy)
		enemy.global_position = point_spawn.global_position
		work_arr.remove_at(index)

func _on_enemy_is_death(enemy :Enemy):
	if rng.randf_range(0.0, 1.0) <= drop_chance:
		var item_drop :ItemBox = item_drop_scene.instantiate()
		world_drop_item.add_child(item_drop)
		item_drop.global_position = enemy.global_position
	emit_signal("add_point")

func _on_enemy_is_ready(enemy :Enemy):
	enemy.is_running = true

func _on_other_level_body_entered(body):
	if not signal_next_level_has_sent and body is Player:
		signal_next_level_has_sent = true
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
