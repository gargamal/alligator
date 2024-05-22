extends Area2D
class_name Bullet

@onready var bullet_time = $bullet_time

@export var exclude_body :Node2D
@export var speed_shoot :float = 1000.0
@export var smooth :float = 2.0
@export var direction :Vector2 :set = set_fire

var is_firing :bool = false

func _process(delta):
	if is_firing:
		global_position = lerp(global_position, global_position + direction * speed_shoot, delta * smooth)

func set_fire(new_direction :Vector2):
	direction = new_direction
	is_firing = true

func _on_body_entered(body):
	if exclude_body and exclude_body != body:
		queue_free()

func _on_bullet_time_timeout():
	queue_free()
