extends Node2D
class_name Level

const WAIT_TIME_MSEC :int = 100
const COLLISION_PLAYER :int = 1
const COLLISION_DECOR :int = 16

@onready var blocker = $blocker
@onready var spawn_point = $spawn_point

signal spawn_new_level(my_self)
signal block_last_level(my_self)
signal i_am_ready_level(my_self)

@export var signal_next_level_has_sent :bool = false
@export var signal_previous_level_has_sent :bool = false
@export var block_player_is_done :bool = false
@export var previous :Level
@export var next :Level
@export var world :Node2D
@export var assault_tank_scene :PackedScene
@export var helicopter_scene :PackedScene
@export var jeep_scene :PackedScene
@export var artillery_scene :PackedScene

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
	
	emit_signal("i_am_ready_level", self)

func spawn(number_of_spawn :int, player :Player, bullet_world :Node2D):
	var work_arr :Array = array_of_spawn.duplicate()
	
	for idx in range(number_of_spawn):
		var index :int = rng.randi_range(0, work_arr.size() - 1)
		var point_spawn :Marker2D = work_arr[index]
		var enemy :Enemy = scene_of_spawn[rng.randi_range(0, scene_of_spawn.size() - 1)].instantiate()
		enemy.world = bullet_world
		enemy.player = player
		enemy.connect("i_am_ready_enemy", _on_enemy_is_ready)
		world.add_child(enemy)
		enemy.global_position = point_spawn.global_position
		work_arr.remove_at(index)

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
