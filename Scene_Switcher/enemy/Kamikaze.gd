extends Enemy
class_name Kamikaze

@onready var animation_player_rotor = $Sprite2D/AnimationPlayer
@onready var cockpit_sprite = $Sprite2D/cockpit_sprite
@onready var weapon_sprite = $Sprite2D/weapon_sprite
@onready var shadow = $Sprite2D/shadow

@export var power = 20

var exploded :bool = false

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

func process_direction():
	var estimate_direction :Vector2 = Vector2.ZERO
	estimate_direction = (player.global_position - global_position).normalized()
	return estimate_direction

func rotation_animation(_delta :float, direction :Vector2):
	cockpit_sprite.skew = lerp(cockpit_sprite.skew, -direction.x * PI/15.0, 0.1)
	weapon_sprite.skew = lerp(cockpit_sprite.skew, -direction.x * PI/15.0, 0.1)
	shadow.skew = lerp(shadow.skew, -direction.x * PI/15.0, 0.1)

func state_machine():
	match enemy_state:
		Enemy_State.IDLE:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.MOVE_SIDE_LEFT, Enemy_State.MOVE_SIDE_RIGHT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
					enemy_state = Enemy_State.MOVE_DOWN
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.SHOOT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
		
		Enemy_State.MOVE_UP:
			if not must_move_up():
				enemy_state = choice_side_direction()
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
		
		Enemy_State.MOVE_DOWN:
			if not must_move_down():
				enemy_state = choice_side_direction()
			elif must_move_up():
				enemy_state = Enemy_State.MOVE_UP

func choice_side_direction() -> Enemy_State:
	if left_wall.is_colliding():
		return Enemy_State.MOVE_SIDE_RIGHT
	elif right_wall.is_colliding():
		return Enemy_State.MOVE_SIDE_LEFT
	else:
		return Enemy_State.MOVE_SIDE_RIGHT if global_position.x < player.global_position.x else Enemy_State.MOVE_SIDE_LEFT

func must_move_up() -> bool:
	return global_position.y > player.global_position.y + 30

func must_move_down() -> bool:
	return global_position.y < player.global_position.y -20 and global_position.y - player.global_position.y > -max_distance_between_player

func _on_explosion_range_body_entered(body):
	if body is Player:
		death()
		body.take_hit(power)
