extends Node2D
class_name Game_Level

const HEIGHT :int = 1080
const max_dist_diedbody :int = 3000

@onready var level :Node2D = $level
@onready var player = $player/player
@onready var level_a_2 = $level/level_a2
@onready var level_a_1 = $level/level_a1
@onready var level_a_0 = $level/level_a0
@onready var enemy = $enemy
@onready var bullet = $bullet

@export var level_scene_1 :PackedScene
@export var level_scene_2 :PackedScene
@export var level_scene_3 :PackedScene
@export var level_scene_4 :PackedScene
@export var level_scene_5 :PackedScene
@export var level_scene_6 :PackedScene
@export var level_scene_7 :PackedScene
@export var level_scene_8 :PackedScene
@export var level_scene_9 :PackedScene
@export var item_scene : PackedScene

var level_scene_instianble :Array =[]
var rng = RandomNumberGenerator.new()
var last_postion_level :Vector2
var id_spawn :int = 1

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

func _on_spawn_new_level(actual_level :Level):
	var level_scene :PackedScene = level_scene_instianble[rng.randi_range(0, level_scene_instianble.size() - 1)]
	var level_inst :Level = level_scene.instantiate()
	level.call_deferred("add_child", level_inst)
	
	level_inst.z_index = -1
	level_inst.position.y = last_postion_level.y - HEIGHT
	last_postion_level = level_inst.position
	level_inst.previous = actual_level.next
	level_inst.previous.next = level_inst
	level_inst.world = enemy
	
	level_inst.connect("spawn_new_level", _on_spawn_new_level)
	level_inst.connect("block_last_level", _on_block_last_level)
	level_inst.connect("i_am_ready_level", _on_level_is_ready)
		
	level_inst.name = "Level_" + str(id_spawn)
	id_spawn += 1

func _on_level_is_ready(p_level :Level):
	p_level.spawn(rng.randi_range(1,3), player, bullet)

func free_level():
	if level.get_child_count() > 4:
		level.get_child(0).queue_free()

func _on_block_last_level(actual_level :Level):
	if actual_level.previous:
		actual_level.previous.block_player()
		free_level()



func _on_clear_timeout():
	for enemy_body in enemy.get_children():
		if enemy_body.global_position.y > player.global_position.y + max_dist_diedbody :
			enemy_body.queue_free()
