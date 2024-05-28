extends Enemy
class_name Artillery

@onready var sprite_2d = $body_sprite
@onready var tower_sprite = $body_sprite/tower_sprite
@onready var animation_player_body = $AnimationPlayer_body
@onready var insight_shoot = $body_sprite/tower_sprite/insight_shoot

func rotation_animation(delta :float, direction :Vector2):
	sprite_2d.rotation = lerp_angle(sprite_2d.rotation, estimate_target_angle(direction), estimate_angle_smooth() * delta)
	collision.rotation = sprite_2d.rotation
	tower_sprite.rotation = global_position.angle_to_point(player.global_position)*1.0-deg_to_rad(90)-sprite_2d.rotation

func _specific_ready():
	target = $body_sprite/tower_sprite/target
	fire_sparkles = $body_sprite/tower_sprite/fire_sparkles

func fire_anim():
	animation_player.play("fire_tank")


func state_machine():
	match enemy_state:
		Enemy_State.IDLE:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.MOVE_SIDE_LEFT, Enemy_State.MOVE_SIDE_RIGHT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
					enemy_state = Enemy_State.MOVE_DOWN
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.SHOOT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			elif not insight_shoot.is_colliding():
				enemy_state = choice_side_direction()
		
		Enemy_State.MOVE_UP:
			if not must_move_up():
				enemy_state = choice_side_direction()
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
		
		Enemy_State.MOVE_DOWN:
			if not must_move_down():
				enemy_state = choice_side_direction()
			elif must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT

func choice_side_direction() -> Enemy_State:
	if left_wall.is_colliding():
		return Enemy_State.MOVE_SIDE_RIGHT
	elif right_wall.is_colliding():
		return Enemy_State.MOVE_SIDE_LEFT
	elif abs(global_position.y - player.global_position.y) > max_distance_between_player:
		return Enemy_State.IDLE
	else:
		return Enemy_State.MOVE_SIDE_RIGHT if global_position.x < player.global_position.x else Enemy_State.MOVE_SIDE_LEFT

func must_move_up() -> bool:
	return global_position.y > player.global_position.y - margin_can_shoot

func must_move_down() -> bool:
	return global_position.y < player.global_position.y - margin_shoot_range and global_position.y - player.global_position.y > -max_distance_between_player

func fire(delta :float):
	#
	bullet_time += delta
	if bullet_time > bullet_cooldown and enemy_state == Enemy_State.SHOOT:
		for i in range (5):
			var ammo = ammo_scene.instantiate()
			world.add_child(ammo)
			ammo.exclude_body = self 
			ammo.global_position = target.global_position
			ammo.origin = target.global_position 
			ammo.direction = (target.global_position - global_position + Vector2(-i*5,i*10)).normalized()
		bullet_time = 0.0
		fire_anim()
