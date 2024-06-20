extends CharacterBody2D
class_name App_Enemy

const TIME_ESTIMATE_DISTANCE_CAN_SHOOT :float = 4.0
const LENGHT_FOLLOW_PLAYER :float = 1000.0

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

# scene node
var collision
var right_shoot
var left_shoot
var collision_shape_2d
var explosion
var smokes
var smoke_20
var smoke_40
var smoke_60
var smoke_80
var death_smoke
var animation_player
var target_follow
var anim_target_follow
var fire_weapon
var explosion_death
var nav_agent_2d


signal i_am_ready_enemy(my_self)
signal i_am_death(my_self)

enum Enemy_State { IDLE, MOVE, SHOOT, AIMING }

var target
var distance_player :float
var enemy_state :Enemy_State = Enemy_State.IDLE
var previous_enemy_state :Enemy_State = Enemy_State.IDLE
var bullet_time :float = 0.0
var life :float = life_max
var margin_can_shoot :float = 400.0
var rng = RandomNumberGenerator.new()
var time_estimate_distance_can_shoot :float = 0.0
var fire_sparkles
var smoke_r :CPUParticles2D
var smoke_l :CPUParticles2D


func _init_ready():
	collision = $CollisionShape2D
	collision_shape_2d = $CollisionShape2D
	explosion = $Explosion
	smokes = $Smokes
	smoke_20 = $Smokes/Smoke20
	smoke_40 = $Smokes/Smoke40
	smoke_60 = $Smokes/Smoke60
	smoke_80 = $Smokes/Smoke80
	death_smoke = $Smokes/Death_Smoke
	explosion_death = $explosion_death
	nav_agent_2d = $NavigationAgent2D
	
	margin_can_shoot = rng.randf_range(100.0 , 500.0)
	time_estimate_distance_can_shoot = rng.randf_range(0.0, TIME_ESTIMATE_DISTANCE_CAN_SHOOT)
	_specific_ready()
	if fire_sparkles:
		fire_sparkles.visible = false
	emit_signal("i_am_ready_enemy", self)


func _specific_ready():
	target = $target
	fire_sparkles = $fire_sparkles
	smoke_r = $body_sprite/move_smoke/smoke_r
	smoke_l = $body_sprite/move_smoke/smoke_l
	right_shoot = $right_shoot
	left_shoot = $left_shoot
	animation_player = $AnimationPlayer
	target_follow = $target_follow
	fire_weapon = $fire_weapon
	anim_target_follow = $anim_target_follow


func set_life_max(new_life_max :float):
	life_max = new_life_max
	life = life_max


func _physics_process(delta :float):
	if is_running and is_alive:
		pass

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


func estimate_target_angle(direction :Vector2) -> float:
	if right_shoot.is_colliding() and left_shoot.is_colliding():
		return 0.0
	else:
		return atan2(-direction.x, direction.y)


func state_machine():
	pass

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
		explosion_death.play()
		is_alive = false
		collision_mask = 4
		collision_layer = 32
		z_index = 0
		if target_follow:
			target_follow.visible = false
		process_explosion()
		if smoke_r and smoke_l:
			smoke_r.emitting = false
			smoke_l.emitting = false
		
		emit_signal("i_am_death", self)

func process_explosion():
	explosion.emitting = true

func process_target_follow():
	if target_follow:
		target_follow.visible = enemy_state == Enemy_State.SHOOT
		if player and target_follow.visible:
			target_follow.global_position = player.target_follow.global_position
			anim_target_follow.play("target_on_player")
		elif anim_target_follow.is_playing() and not target_follow.visible:
			anim_target_follow.stop()
