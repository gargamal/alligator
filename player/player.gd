extends CharacterBody2D
class_name Player

enum Movement_State { IDLE, RUN }
enum Shoot_State { IDLE, SHOOT }
enum Level_Weapon { BASIC, DOUBLE, TRIPLE }

@onready var main_target = $targets/main_target
@onready var left_target = $targets/left_target
@onready var right_target = $targets/right_target
@onready var cockpit_sprite = $cockpit_sprite
@onready var weapon_sprite = $weapon_sprite
@onready var weapon_double_sprite = $weapon_double_sprite
@onready var life_level = $life_level
@onready var main_fire = $targets/main_target/fire
@onready var left_fire = $targets/left_target/fire
@onready var right_fire = $targets/right_target/fire

@export var speed :float = 500.0
@export var life :float = 50.0
@export var life_max :float = 50.0
@export var smooth :float = 1.0
@export var bullet_cooldown :float = 0.2
@export var percent_healing :float = 0.25
@export var world :Node2D
@export var bullet_scene :PackedScene

var skew_grain = 10.0
var input_dir :Vector2
var movement_state :Movement_State = Movement_State.IDLE
var shoot_state :Shoot_State = Shoot_State.IDLE
var bullet_time :float = 0.0
var level_weapon :Level_Weapon = Level_Weapon.BASIC

func _ready():
	life = life_max
	life_level.visible = true
	animation_weapon()

func _physics_process(delta :float):
	velocity = lerp(velocity, input_dir * get_speed(), smooth * delta)
	
	cockpit_sprite.skew = lerp(cockpit_sprite.skew, input_dir.x * PI/15.0, 0.1)
	weapon_sprite.skew = lerp(cockpit_sprite.skew, input_dir.x * PI/15.0, 0.1)
	
	move_and_slide()
	manage_shoot(delta)

func get_speed() -> float:
	return speed * (0.75 if input_dir.y > 0 else 1.0)

func _input(_event):
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") \
			or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		movement_state = Movement_State.RUN

	elif Input.is_action_just_released("ui_down") or Input.is_action_just_released("ui_up") \
			or Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		input_dir = Vector2.ZERO
		movement_state = Movement_State.IDLE
	
	if Input.is_action_pressed("ui_shoot"):
		shoot_state = Shoot_State.SHOOT
	
	elif Input.is_action_just_released("ui_shoot"):
		shoot_state = Shoot_State.IDLE

func manage_shoot(delta :float):
	bullet_time += delta
	if bullet_time > bullet_cooldown and shoot_state == Shoot_State.SHOOT:
		var bullet :Bullet = bullet_scene.instantiate()
		world.add_child(bullet)
		bullet.exclude_body = self 
		bullet.global_position = main_target.global_position
		bullet.direction = (main_target.global_position - global_position).normalized()
		bullet.origin = main_target.global_position
		bullet_time = 0.0

func take_hit(power: int):
	var tween :Tween = get_tree().create_tween()
	tween.tween_method(set_life, life, life- power, 1.0).set_trans(Tween.TRANS_SINE)
	
	if level_weapon != Level_Weapon.BASIC:
		@warning_ignore("int_as_enum_without_cast")
		level_weapon -= 1
		animation_weapon()

func take_itembox(itembox :ItemBox.Type_ItemBox):
	match itembox:
		ItemBox.Type_ItemBox.HEAL: 
			var tween :Tween = get_tree().create_tween()
			tween.tween_method(set_life, life, life + (life_max - life) * percent_healing, 1.0).set_trans(Tween.TRANS_SINE)
			
		ItemBox.Type_ItemBox.WEAPON:
			if level_weapon != Level_Weapon.TRIPLE:
				@warning_ignore("int_as_enum_without_cast")
				level_weapon += 1
				animation_weapon()

func set_life(new_life :float):
	life = new_life
	if life > 1.0:
		life_level.texture.width = int(life / life_max * 100.0 + .5)
	else:
		life_level.visible = false

func animation_weapon():
	match level_weapon:
		Level_Weapon.BASIC:
			weapon_sprite.visible = true
			weapon_double_sprite.visible = false
		Level_Weapon.DOUBLE:
			weapon_sprite.visible = false
			weapon_double_sprite.visible = true
		Level_Weapon.TRIPLE:
			weapon_sprite.visible = true
			weapon_double_sprite.visible = true

