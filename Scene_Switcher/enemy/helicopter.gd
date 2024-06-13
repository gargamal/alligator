extends Enemy
class_name Helicopter

@onready var animation_player_rotor = $Sprite2D/AnimationPlayer
@onready var cockpit_sprite = $Sprite2D/cockpit_sprite
@onready var weapon_sprite = $Sprite2D/weapon_sprite
@onready var shadow = $Sprite2D/shadow


func death():
	super()
	animation_player_rotor.stop()
	z_index = 0
	var tween :Tween = get_tree().create_tween()
	tween.tween_method(set_shadow_postion, shadow.position, Vector2(-5.0, 5.0), 0.5).set_trans(Tween.TRANS_SINE)

func _specific_ready():
	target = $target
	fire_sparkles = $fire_sparkles

func set_shadow_postion(shadow_position :Vector2):
	shadow.position = shadow_position

func rotation_animation(_delta :float, direction :Vector2):
	cockpit_sprite.skew = lerp(cockpit_sprite.skew, -direction.x * PI/15.0, 0.1)
	weapon_sprite.skew = lerp(cockpit_sprite.skew, -direction.x * PI/15.0, 0.1)
	shadow.skew = lerp(shadow.skew, -direction.x * PI/15.0, 0.1)
