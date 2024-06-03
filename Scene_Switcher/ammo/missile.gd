extends RigidBody2D
class_name Missile

@onready var explosion = $Explosion
@onready var sprite_2d = $Sprite2D
@onready var target_world = $TargetWorld

@export var exclude_body :Node2D
@export var speed_shoot :float = 50.0
@export var smooth :float = 2.0
@export var direction :Vector2 :set = set_fire
@export var power :int = 1
@export var origin :Vector2
@export var distance_max :float = 400.0
@export var target_scene :PackedScene
@export var world :Node2D

var is_firing :bool = false
var colliders_known :Array = []

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
	await get_tree().create_timer(0.1).timeout
	queue_free()

func set_fire(new_direction :Vector2):
	direction = new_direction
	is_firing = true

func basic_shoot(target_dir :Marker2D, target_pos :Marker2D):
	var target :Target = target_scene.instantiate()
	world.add_child(target)
	target.exclude_body = self 
	target.global_position = player.global_position
	target.direction = (target_dir.global_position - global_position).normalized() 
	target.origin = target_pos.global_position