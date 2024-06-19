extends CharacterBody2D
class_name Player


enum Movement_State { IDLE, RUN }
enum Shoot_State { IDLE, SHOOT }
enum Level_Weapon { BASIC, DOUBLE, TRIPLE }


const DURATION_OVERHEAT_WAIT :float = 1.0
const WEAPON_COLDOWN :float = 1.0
const WEAPON_HEATDOWN :float = 0.5
const WEAPON_OVERHEAT_LIMIT :float = 100.0
const WEAPON_COLOR :Color = Color("4b4b4b")


@onready var main_target = $cockpit_sprite/weapon_sprite/targets/main_target
@onready var left_target = $cockpit_sprite/weapon_sprite/targets/left_target
@onready var right_target = $cockpit_sprite/weapon_sprite/targets/right_target
@onready var cockpit_sprite = $cockpit_sprite
@onready var weapon_sprite = $cockpit_sprite/weapon_sprite
@onready var weapon_double_sprite = $cockpit_sprite/weapon_double_sprite
@onready var life_level = $hud_player/life_level
@onready var heat_level = $hud_player/heat_level
@onready var anim_smoke_fire_basic = $cockpit_sprite/weapon_sprite/fire_sparkles/anim_smoke_fire_basic
@onready var anim_smoke_fire_left = $cockpit_sprite/weapon_sprite/fire_sparkles/anim_smoke_fire_left
@onready var anim_smoke_fire_right = $cockpit_sprite/weapon_sprite/fire_sparkles/anim_smoke_fire_right
@onready var overheat_gun = $sound/overheat_gun
@onready var anim_weapon = $anim_weapon
@onready var target_follow = $target_follow
@onready var shadow = $cockpit_sprite/shadow
@onready var smoke_20 = $cockpit_sprite/Smokes/Smoke20
@onready var smoke_40 = $cockpit_sprite/Smokes/Smoke40
@onready var smoke_60 = $cockpit_sprite/Smokes/Smoke60
@onready var smoke_80 = $cockpit_sprite/Smokes/Smoke80
@onready var death_smoke = $cockpit_sprite/Smokes/Death_Smoke
@onready var explosion_death = $explosion_death
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var explosion = $Explosion
@onready var collision = $col


signal i_am_dead(my_self)


@export var speed :float = 500.0
@export var side_multiplier :float = 1.5
@export var life :float = 50.0
@export var life_max :float = 50.0 :set = set_life_max
@export var smooth :float = 1.0
@export var bullet_cooldown :float = 0.2
@export var percent_healing :float = 0.25
@export var minimun_healing :float = 20.0
@export var world :Node2D
@export var bullet_scene :PackedScene
@export var power :float = 1.0


var skew_grain = 10.0
var input_dir :Vector2
var movement_state :Movement_State = Movement_State.IDLE
var shoot_state :Shoot_State = Shoot_State.IDLE
var bullet_time :float = 0.0
var level_weapon :Level_Weapon = Level_Weapon.BASIC
var bullet_idx :int = 0
var rng = RandomNumberGenerator.new()
var weapon_heat :float = 0.0
var weapon_coldown :float = 0.01 
var time_overheat_duration :float = 0.0
var overheat :bool = false
var vue_direction :Vector2 = Vector2(0, -1)


func set_life_max(new_life_max :float):
	life_max = new_life_max
	life = life_max


func _ready():
	set_life_max(life_max)
	life_level.visible = true
	set_life(life)
	animation_weapon()


func _physics_process(delta :float):
	if abs(vue_direction.y) < 1:
		velocity.x = lerp(velocity.x, input_dir.x * get_speed(), smooth * delta)
		velocity.y = lerp(velocity.y, input_dir.y * get_speed() * side_multiplier, smooth * delta)
	
		cockpit_sprite.skew = lerp(cockpit_sprite.skew, input_dir.y * PI/20.0, 0.1)
		weapon_sprite.skew = lerp(cockpit_sprite.skew, input_dir.y * PI/20.0, 0.1)
		
	elif abs(vue_direction.x) < 1:
		velocity.x = lerp(velocity.x, input_dir.x * get_speed() * side_multiplier, smooth * delta)
		velocity.y = lerp(velocity.y, input_dir.y * get_speed(), smooth * delta)
	
		cockpit_sprite.skew = lerp(cockpit_sprite.skew, input_dir.x * PI/20.0, 0.1)
		weapon_sprite.skew = lerp(cockpit_sprite.skew, input_dir.x * PI/20.0, 0.1)
	
	move_and_slide()


func _process(delta):
	time_overheat_duration += delta
	bullet_time += delta
	manage_shoot()
	
	if Input.is_action_just_pressed("ui_right_rotate"):
		vue_direction = vue_direction.rotated(PI / 2.0)
	
	elif Input.is_action_just_pressed("ui_left_rotate"):
		vue_direction = vue_direction.rotated(-PI / 2.0)
	
	cockpit_sprite.rotation = lerp_angle(cockpit_sprite.rotation, vue_direction.angle_to(Vector2(0, -1)), delta * 10.0)
	collision.rotation = cockpit_sprite.rotation


func get_speed() -> float:
	return speed * (0.85 if input_dir.y > 0 else 1.0)


func _input(_event):
	if Input.is_action_just_pressed("ui_left_rotate") or Input.is_action_just_pressed("ui_right_rotate"):
		input_dir = Vector2.ZERO
		movement_state = Movement_State.IDLE
	
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") \
			or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		input_dir = input_dir.rotated(rotation)
		movement_state = Movement_State.RUN

	elif Input.is_action_just_released("ui_down") or Input.is_action_just_released("ui_up") \
			or Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		input_dir = Vector2.ZERO
		movement_state = Movement_State.IDLE
	
	if not overheat and Input.is_action_pressed("ui_shoot"):
		shoot_state = Shoot_State.SHOOT
	
	elif shoot_state != Shoot_State.IDLE and Input.is_action_just_released("ui_shoot"):
		shoot_state = Shoot_State.IDLE


func manage_shoot():
	weapon_heat_process()
	
	if not overheat and bullet_time > bullet_cooldown and shoot_state == Shoot_State.SHOOT:
		match level_weapon:
			Level_Weapon.BASIC: 
				basic_shoot(main_target,main_target)
				anim_smoke_fire_basic.play("player_fire_basic")
				
			Level_Weapon.DOUBLE:
				double_shoot()
				anim_smoke_fire_left.play("player_fire_left")
				anim_smoke_fire_right.play("player_fire_right")
				
			Level_Weapon.TRIPLE: 
				triple_shoot()
				anim_smoke_fire_basic.play("player_fire_basic")
				anim_smoke_fire_left.play("player_fire_left")
				anim_smoke_fire_right.play("player_fire_right")


func basic_shoot(target_dir :Marker2D, target_pos :Marker2D):
	if not overheat:
		var bullet :Bullet = bullet_scene.instantiate()
		world.add_child(bullet)
		bullet.exclude_body = self 
		bullet.global_position = target_pos.global_position
		bullet.global_rotation = cockpit_sprite.global_rotation
		bullet.direction = (target_dir.global_position - global_position).normalized() 
		bullet.origin = target_pos.global_position
		bullet.power = power
		bullet_time = 0.0
		bullet.flip_v = true
		next_shoot()


func double_shoot():
	basic_shoot(main_target,left_target)
	basic_shoot(main_target,right_target)


func triple_shoot():
	basic_shoot(main_target,main_target)
	basic_shoot(main_target,left_target)
	basic_shoot(main_target,right_target)


func take_hit(p_power: int):
	var tween :Tween = get_tree().create_tween()
	tween.tween_method(set_life, life, life - p_power, 1.0).set_trans(Tween.TRANS_SINE)
	process_aniamtion_smoke()
	
	if life < life_max * .5 and level_weapon != Level_Weapon.BASIC:
		@warning_ignore("int_as_enum_without_cast")
		level_weapon -= 1
		animation_weapon()


func take_itembox(itembox :ItemBox.Type_ItemBox):
	match itembox:
		ItemBox.Type_ItemBox.HEAL:
			var tween :Tween = get_tree().create_tween()
			tween.tween_method(set_life, life, life + calculate_added_life(), 1.0).set_trans(Tween.TRANS_SINE)
			process_aniamtion_smoke()
			
		ItemBox.Type_ItemBox.WEAPON:
			if level_weapon != Level_Weapon.TRIPLE:
				@warning_ignore("int_as_enum_without_cast")
				level_weapon += 1
				animation_weapon()

func calculate_added_life() -> float:
	var life_added :float = (life_max - life) * percent_healing
	life_added = minimun_healing if life_added < minimun_healing else life_added
	if life + life_added > life_max:
		life_added = life_max - life
	return life_added


func set_life(new_life :float):
	life = new_life
	if life > 1.0:
		life_level.texture.width = int(life / life_max * 100.0 + .5)
	elif life_level.visible:
		explosion.emitting = true
		animated_sprite_2d.stop()
		life_level.visible = false
		death_smoke.emitting = true
		explosion_death.play()
		await get_tree().create_timer(1.5).timeout
		emit_signal("i_am_dead", self)


func animation_weapon():
	match level_weapon:
		Level_Weapon.BASIC:
			weapon_sprite.visible = true
			weapon_double_sprite.visible = false
			shadow.frame = 0
		Level_Weapon.DOUBLE:
			weapon_sprite.visible = false
			weapon_double_sprite.visible = true
			shadow.frame = 1
		Level_Weapon.TRIPLE:
			weapon_sprite.visible = true
			weapon_double_sprite.visible = true
			shadow.frame = 2


func next_shoot():
	bullet_idx = rng.randi_range(0,3)
	get_tree().create_timer(rng.randf_range(0.1, 0.2))
	get_node("sound/shoot_gun_" + str(bullet_idx)).play()


func weapon_heat_process():
	if overheat and time_overheat_duration > DURATION_OVERHEAT_WAIT:
		overheat = false
		weapon_heat = 0.0
	
	elif not overheat:
		if weapon_heat > WEAPON_OVERHEAT_LIMIT:
			time_overheat_duration = 0.0
			overheat = true
			overheat_gun.play()
			anim_weapon.play("overheat_weapon")
		
		elif shoot_state == Shoot_State.SHOOT:
			weapon_heat += WEAPON_HEATDOWN
		
		elif weapon_heat > 0.0:
			weapon_heat -= WEAPON_COLDOWN
			weapon_heat = weapon_heat if weapon_heat > 0.0 else 0.0
	
	heat_level.value = int(weapon_heat + .5)
	var overheat_color :Color = Color(WEAPON_COLOR.r + weapon_heat * .25 / 100.0, 
										WEAPON_COLOR.g - weapon_heat * .25 / 100.0, 
										WEAPON_COLOR.b - weapon_heat * .25 / 100.0)
	weapon_sprite.self_modulate = overheat_color
	weapon_double_sprite.self_modulate = overheat_color


func process_aniamtion_smoke():
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


static func get_life_max_with_difficulty(p_life_max :float, difficulty_level :App_Game.Type_Difficulty) -> float:
	match difficulty_level:
		App_Game.Type_Difficulty.EASY: return int(p_life_max * 2.0 + 0.5)
		App_Game.Type_Difficulty.HARD: return int(float(p_life_max) * 0.75 + 0.5)
		_: return p_life_max


static func get_minimun_healing_with_difficulty(p_minimun_healing :int, difficulty_level :App_Game.Type_Difficulty) -> int:
	match difficulty_level:
		App_Game.Type_Difficulty.EASY: return int(p_minimun_healing * 1.5 + 0.5)
		App_Game.Type_Difficulty.HARD: return int(float(p_minimun_healing) * 0.5 + 0.5)
		_: return p_minimun_healing
