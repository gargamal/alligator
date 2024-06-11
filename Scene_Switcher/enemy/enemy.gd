extends CharacterBody2D
class_name Enemy

const TIME_ESTIMATE_DISTANCE_CAN_SHOOT :float = 4.0

@export var speed :float = 200.0
@export var speed_up :float = 800.0
@export var life_max :float = 10.0 : set = set_life_max
@export var smooth :float = 5.0
@export var player :Player
@export var max_distance_between_player :float = 900.0
@export var margin_shoot_range :float = 500.0
@export var bullet_cooldown :float = 0.5
@export var world :Node2D
@export var ammo_scene :PackedScene
@export var is_running :bool = false
@export var is_alive : bool = true

@onready var left_wall = $left_wall
@onready var right_wall = $right_wall
@onready var collision = $CollisionShape2D
@onready var right_shoot = $right_shoot
@onready var left_shoot = $left_shoot
@onready var collision_shape_2d = $CollisionShape2D
@onready var explosion = $Explosion
@onready var smoke_20 = $Smokes/Smoke20
@onready var smoke_40 = $Smokes/Smoke40
@onready var smoke_60 = $Smokes/Smoke60
@onready var smoke_80 = $Smokes/Smoke80
@onready var death_smoke = $Smokes/Death_Smoke
@onready var animation_player = $AnimationPlayer
@onready var target_follow = $target_follow
@onready var anim_target_follow = $anim_target_follow
@onready var fire_weapon = $fire_weapon


signal i_am_ready_enemy(my_self)
signal i_am_death(my_self)

enum Enemy_State { IDLE, MOVE_UP, MOVE_DOWN, MOVE_SIDE_LEFT, MOVE_SIDE_RIGHT, SHOOT }

var target
var enemy_state :Enemy_State = Enemy_State.IDLE
var previous_enemy_state :Enemy_State = Enemy_State.IDLE
var bullet_time :float = 0.0
var life :float = life_max
var margin_can_shoot :float = 400.0
var rng = RandomNumberGenerator.new()
var time_estimate_distance_can_shoot :float = 0.0
var fire_sparkles

func _ready():
	emit_signal("i_am_ready_enemy", self)
	margin_can_shoot = rng.randf_range(100.0 , 500.0)
	time_estimate_distance_can_shoot = rng.randf_range(0.0, TIME_ESTIMATE_DISTANCE_CAN_SHOOT)
	_specific_ready()
	fire_sparkles.visible = false

func set_life_max(new_life_max :int):
	life_max = new_life_max
	life = life_max

func _specific_ready():
	target = $target
	fire_sparkles = $fire_sparkles

func _physics_process(delta :float):
	if is_running and is_alive:
		var direction :Vector2 = process_direction()
		velocity = lerp(velocity, process_velocity(direction), smooth * delta)
		rotation_animation(delta, direction)
		move_and_slide()
		
		previous_enemy_state = enemy_state

func _process(delta :float):
	if is_running and is_alive:
		process_distance_can_shoot(delta)
		state_machine()
		fire(delta)
		process_target_follow()

func process_distance_can_shoot(delta :float):
	time_estimate_distance_can_shoot += delta
	if time_estimate_distance_can_shoot > TIME_ESTIMATE_DISTANCE_CAN_SHOOT:
		margin_can_shoot = rng.randf_range(100.0 , 500.0)
		time_estimate_distance_can_shoot = 0.0

func rotation_animation(_delta :float, _direction :Vector2):
	pass

func estimate_angle_smooth() -> float:
	match enemy_state:
		Enemy_State.MOVE_SIDE_LEFT, Enemy_State.MOVE_SIDE_RIGHT: return 2.0
		_: return 5.0

func estimate_target_angle(direction :Vector2) -> float:
	if right_shoot.is_colliding() and left_shoot.is_colliding():
		return 0.0
	else:
		return atan2(-direction.x, direction.y)

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
		bullet_time = bullet_cooldown * 0.825
	#
	bullet_time += delta
	if bullet_time > bullet_cooldown and enemy_state == Enemy_State.SHOOT:
		fire_weapon.fire()
		var ammo = ammo_scene.instantiate()
		world.add_child(ammo)
		ammo.exclude_body = self 
		ammo.global_position = target.global_position
		ammo.origin = target.global_position
		ammo.direction = Vector2(0,1)
		bullet_time = 0.0
		fire_anim()

func fire_anim():
	animation_player.play("fire_basis")

func take_hit(power: int):
	life -= power
	
	var quotient:float = life/life_max
	
	if quotient > 0.8:
		pass
	elif quotient > 0.6:
		smoke_20.emitting = true
	elif quotient > 0.4:
		if not smoke_20.emitting: smoke_20.emitting = true
		smoke_40.emitting = true
	elif quotient > 0.2:
		if not smoke_20.emitting: smoke_20.emitting = true
		if not smoke_40.emitting: smoke_40.emitting = true
		smoke_60.emitting = true
	elif quotient > 0.0:
		if not smoke_20.emitting: smoke_20.emitting = true
		if not smoke_40.emitting: smoke_40.emitting = true
		if not smoke_60.emitting: smoke_60.emitting = true
		smoke_80.emitting = true
	else:
		if not smoke_20.emitting: smoke_20.emitting = true
		if not smoke_40.emitting: smoke_40.emitting = true
		if not smoke_60.emitting: smoke_60.emitting = true
		if not smoke_80.emitting: smoke_60.emitting = true
		death_smoke.emitting = true
		death()

func death():
	if is_alive:
		is_alive = false
		collision_mask = 4
		collision_layer = 32
		target_follow.visible = false
		process_explosion()
		emit_signal("i_am_death", self)

func process_explosion():
	explosion.emitting = true

func process_target_follow():
	target_follow.visible = enemy_state == Enemy_State.SHOOT
	if player and target_follow.visible:
		target_follow.global_position = player.target_follow.global_position
		anim_target_follow.play("target_on_player")
	elif anim_target_follow.is_playing() and not target_follow.visible:
		anim_target_follow.stop()
