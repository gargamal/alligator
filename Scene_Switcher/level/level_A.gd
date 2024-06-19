extends Node2D
class_name Level_A


@onready var spawn_point = $spawn_point

@export var item_scene : PackedScene
@export var max_enemy :int = 4
@export var world :Node2D
@export var world_drop_item :Node2D
@export var assault_tank_scene :PackedScene = load("res://Scene_Switcher/enemy/assault_tank.tscn")
@export var helicopter_scene :PackedScene = load("res://Scene_Switcher/enemy/helicopter.tscn")
@export var jeep_scene :PackedScene = load("res://Scene_Switcher/enemy/jeep.tscn")
@export var artillery_scene :PackedScene = load("res://Scene_Switcher/enemy/artillery.tscn")
@export var kamikaze_scene :PackedScene = load("res://Scene_Switcher/enemy/Kamikaze.tscn")
@export var item_drop_scene :PackedScene = load("res://Scene_Switcher/enemy/Drop/item_drop.tscn")
@export_range(0.0, 1.0) var drop_chance :float = 0.2
@export var point_per_kill :int = 1


var array_of_spawn :Array = []
var scene_of_spawn :Array = []


func _ready():
	if spawn_point:
		array_of_spawn = spawn_point.get_children()
		if assault_tank_scene:
			scene_of_spawn.append(assault_tank_scene)
		if helicopter_scene:
			scene_of_spawn.append(helicopter_scene)
		if jeep_scene:
			scene_of_spawn.append(jeep_scene)
		if artillery_scene:
			scene_of_spawn.append(artillery_scene)
		if kamikaze_scene:
			scene_of_spawn.append(kamikaze_scene)
