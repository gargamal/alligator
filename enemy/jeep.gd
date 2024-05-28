extends Enemy
class_name Jeep

@onready var sprite_2d = $body_sprite

func _specific_ready():
	target = $target
	fire_sparkles = $fire_sparkles

func rotation_animation(delta :float, direction :Vector2):
	sprite_2d.rotation = lerp_angle(sprite_2d.rotation, estimate_target_angle(direction), estimate_angle_smooth() * delta)
	collision.rotation = sprite_2d.rotation

