extends RigidBody2D
class_name Bullet

@onready var explosion = $Explosion
@onready var sprite_2d = $Sprite2D
@onready var bullet_impacts = $Bullet_Impacts

@export var exclude_body :Node2D
@export var speed_shoot :float = 50.0
@export var smooth :float = 2.0
@export var direction :Vector2 :set = set_fire
@export var power :int = 1
@export var origin :Vector2
@export var distance_max :float = 400.0
@export var flip_v :bool = false :set = set_flip_v

var is_firing :bool = false
var colliders_known :Array = []

func set_flip_v(new_flip_v :bool):
	flip_v = new_flip_v
	sprite_2d.flip_v = flip_v

func _process(_delta):
	if is_firing and explosion and not explosion.emitting:
		if origin.distance_to(global_position) > distance_max:
			queue_free()
		
		else:
			var velocity :Vector2 = Vector2.ZERO
			velocity = direction * speed_shoot
			var collider :KinematicCollision2D = move_and_collide(velocity)
			if collider and not collider in colliders_known:
				colliders_known.append(collider)
				var obj_colide = collider.get_collider()
				if obj_colide != exclude_body:
					if obj_colide is Player:
						obj_colide.take_hit(power)
						free_bullet()
					elif obj_colide is Enemy and obj_colide.is_alive:
						obj_colide.take_hit(power)
						free_bullet()
					elif "decor_static" in obj_colide.get_groups():
						free_bullet()

func free_bullet():
	sprite_2d.visible = false
	explosion.emitting = true
	collision_layer = 0
	collision_mask = 0
	bullet_impacts._on_impact()


func set_fire(new_direction :Vector2):
	direction = new_direction
	is_firing = true


func _on_bullet_impacts_finished():
	queue_free()
