extends Enemy
class_name Assault_Tank

@onready var sprite_2d = $body_sprite
@onready var tower_sprite = $body_sprite/tower_sprite


func _specific_ready():
	target = $body_sprite/target
	fire_sparkles = $body_sprite/tower_sprite/fire_sparkles

func _physics_process(delta):
	super(delta)
	tower_sprite.global_rotation = -PI

func rotation_animation(delta :float, direction :Vector2):
	sprite_2d.rotation = lerp_angle(sprite_2d.rotation, estimate_target_angle(direction), estimate_angle_smooth() * delta)
	collision.rotation = sprite_2d.rotation

func fire_anim():
	animation_player.play("fire_tank")
