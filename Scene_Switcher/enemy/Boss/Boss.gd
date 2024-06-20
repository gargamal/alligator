extends App_Enemy
class_name Boss

@onready var insight_shoot = $mesh/weapon/Weapon_Sprite/RayCast2D

func _ready(): 
	_init_ready()

func death():
	if is_alive:
		is_alive = false
		collision_mask = 4
		collision_layer = 32
		z_index = 0
		process_explosion()
		emit_signal("i_am_dead_boss", self)
		target_follow.visible = false

func state_machine():
	match enemy_state:
		Enemy_State.IDLE:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
				bullet_time = 0.0
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.MOVE_SIDE_LEFT, Enemy_State.MOVE_SIDE_RIGHT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
					enemy_state = Enemy_State.MOVE_DOWN
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
				bullet_time = 0.0
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
				bullet_time = 0.0
		
		Enemy_State.MOVE_DOWN:
			if not must_move_down():
				enemy_state = choice_side_direction()
			elif must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
				bullet_time = 0.0

func choice_side_direction() -> Enemy_State:
	if left_wall.is_colliding():
		return Enemy_State.MOVE_SIDE_RIGHT
	elif right_wall.is_colliding():
		return Enemy_State.MOVE_SIDE_LEFT
	elif abs(global_position.y - player.global_position.y) > max_distance_between_player:
		return Enemy_State.IDLE
	elif global_position.x < 940 :
		return Enemy_State.MOVE_SIDE_RIGHT  
	elif global_position.x > 980 :
		return Enemy_State.MOVE_SIDE_LEFT
	else :
		return Enemy_State.IDLE

func must_move_up() -> bool:
	return global_position.y > player.global_position.y - margin_can_shoot

func must_move_down() -> bool:
	return global_position.y < player.global_position.y - margin_shoot_range and global_position.y - player.global_position.y > -max_distance_between_player
