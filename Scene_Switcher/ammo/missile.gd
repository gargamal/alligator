extends Area2D
class_name Missile

@onready var explosion = $Explosion
@onready var sprite_2d = $Sprite_Missile
@onready var target_world = $TargetWorld
@onready var bullet_impacts = $Bullet_Impacts

@export var exclude_body :Node2D
@export var speed_shoot :float = 50.0
@export var smooth :float = 2.0
@export var direction :Vector2
@export var power :int = 1
@export var origin :Vector2
@export var distance_max :float = 4000.0
@export var target_scene :PackedScene
@export var world :Node2D

var velocity :Vector2 = Vector2.ZERO
var is_firing :bool = false
var colliders_known :Array = []

func _process(_delta):
	if is_firing and explosion and not explosion.emitting:
		if origin.distance_to(global_position) > distance_max:
			queue_free()
		
		elif is_firing:
			global_position = global_position + velocity


func free_bullet():
	sprite_2d.visible = false
	explosion.emitting = true
	bullet_impacts._on_impact()
	await get_tree().create_timer(0.3).timeout
	queue_free()

func set_fire(new_direction :Vector2, player :Player):
	direction = new_direction
	is_firing = true
	var speed = global_position.distance_to(player.global_position)
	velocity = direction * speed / 180
