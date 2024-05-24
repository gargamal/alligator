extends Enemy
class_name Helicopter

@onready var animation_player_rotor = $Sprite2D/AnimationPlayer
@onready var cockpit_sprite = $Sprite2D/cockpit_sprite
@onready var weapon_sprite = $Sprite2D/weapon_sprite

func death():
	super()
	animation_player_rotor.stop()
	z_index = 0

func rotation_animation(_delta :float, direction :Vector2):
	cockpit_sprite.skew = lerp(cockpit_sprite.skew, -direction.x * PI/15.0, 0.1)
	weapon_sprite.skew = lerp(cockpit_sprite.skew, -direction.x * PI/15.0, 0.1)
