extends CharacterBody2D
class_name Enemy

@export var speed :float = 200.0
@export var speed_up :float = 800.0
@export var life :int = 10
@export var power :int = 10
@export var smooth :float = 5.0
@export var player :Player
@export var max_distance_between_player :float = 900.0
@export var margin_can_shoot :float = 400.0
@export var margin_shoot_range :float = 500.0
@export var bullet_cooldown :float = 0.75
@export var world :Node2D
@export var bombshell_scene :PackedScene

@onready var target = $target
@onready var left_wall = $left_wall
@onready var right_wall = $right_wall
@onready var sprite_2d = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var right_shoot = $right_shoot
@onready var left_shoot = $left_shoot

enum Enemy_State { IDLE, MOVE_UP, MOVE_DOWN, MOVE_SIDE_LEFT, MOVE_SIDE_RIGHT, SHOOT }

var enemy_state :Enemy_State = Enemy_State.IDLE
var previous_enemy_state :Enemy_State = Enemy_State.IDLE
var bullet_time :float = 0.0

func _physics_process(delta):
	state_machine()
	var direction :Vector2 = process_direction()
	velocity = lerp(velocity, process_velocity(direction), smooth * delta)
	sprite_2d.rotation = lerp_angle(sprite_2d.rotation, estimate_target_angle(direction), estimate__angle_smooth() * delta)
	collision.rotation = sprite_2d.rotation
	fire(delta)
	move_and_slide()
	
	previous_enemy_state = enemy_state

func estimate__angle_smooth() -> float:
	match enemy_state:
		Enemy_State.MOVE_SIDE_LEFT, Enemy_State.MOVE_SIDE_RIGHT: return 2.0
		_: return 5.0

func estimate_target_angle(direction :Vector2) -> float:
	if right_shoot.is_colliding() and left_shoot.is_colliding():
		return 0.0
	else:
		return atan2(direction.x, -direction.y)

func process_direction():
	var estimate_direction :Vector2 = Vector2.ZERO
	match enemy_state:
		Enemy_State.MOVE_SIDE_LEFT: estimate_direction = Vector2(-1, 0)
		Enemy_State.MOVE_SIDE_RIGHT: estimate_direction = Vector2(1, 0)
		Enemy_State.MOVE_UP: estimate_direction = Vector2(0, -1)
		Enemy_State.MOVE_DOWN: estimate_direction = Vector2(0, 1)
	return estimate_direction

func process_velocity(direction :Vector2) -> Vector2:
	var estimate_velocity :Vector2 = Vector2.ZERO
	match enemy_state:
		Enemy_State.MOVE_SIDE_LEFT: estimate_velocity = direction * speed
		Enemy_State.MOVE_SIDE_RIGHT: estimate_velocity = direction * speed
		Enemy_State.MOVE_UP: estimate_velocity = direction * speed_up
		Enemy_State.MOVE_DOWN: estimate_velocity = direction * speed
	return estimate_velocity

func state_machine():
	match enemy_state:
		Enemy_State.IDLE:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			elif right_shoot.is_colliding() and left_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.MOVE_SIDE_LEFT, Enemy_State.MOVE_SIDE_RIGHT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
					enemy_state = Enemy_State.MOVE_DOWN
			elif right_shoot.is_colliding() and left_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.SHOOT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			elif not right_shoot.is_colliding() or not left_shoot.is_colliding():
				enemy_state = choice_side_direction()
		
		Enemy_State.MOVE_UP:
			if not must_move_up():
				enemy_state = choice_side_direction()
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			elif right_shoot.is_colliding() and left_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
		
		Enemy_State.MOVE_DOWN:
			if not must_move_down():
				enemy_state = choice_side_direction()
			elif must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif right_shoot.is_colliding() and left_shoot.is_colliding():
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
	if previous_enemy_state != enemy_state and enemy_state == Enemy_State.SHOOT:
		bullet_time = 0.0
	
	bullet_time += delta
	if bullet_time > bullet_cooldown and enemy_state == Enemy_State.SHOOT:
		var bombshell :Bombshell = bombshell_scene.instantiate()
		world.add_child(bombshell)
		bombshell.exclude_body = self 
		bombshell.global_position = target.global_position
		bombshell.direction = (target.global_position - global_position).normalized()
		bullet_time = 0.0
