extends RigidBody2D
class_name Bullet

@onready var bullet_time = $bullet_time

@export var exclude_body :Node2D
@export var speed_shoot :float = 50.0
@export var smooth :float = 2.0
@export var direction :Vector2 :set = set_fire
@export var power :int = 1

var is_firing :bool = false

func _process(delta):
	if is_firing:
		var velocity :Vector2 = Vector2.ZERO
		velocity = direction * speed_shoot
		var collider :KinematicCollision2D = move_and_collide(velocity)
		if collider:
			var obj_colide = collider.get_collider()
			if obj_colide is Player:
				obj_colide.take_hit(power)
			elif obj_colide is Enemy:
				obj_colide.take_hit(power)
			queue_free()

func set_fire(new_direction :Vector2):
	direction = new_direction
	is_firing = true

func _on_bullet_time_timeout():
	queue_free()
