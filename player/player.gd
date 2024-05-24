extends CharacterBody2D
class_name Player

enum Movement_State { IDLE, RUN }
enum Shoot_State { IDLE, SHOOT }

@onready var target = $target
@onready var cockpit_sprite = $cockpit_sprite
@onready var weapon_sprite = $weapon_sprite


@export var speed :float = 500.0
@export var life :int = 100
@export var smooth :float = 1.0
@export var bullet_cooldown :float = 0.2
@export var world :Node2D
@export var bullet_scene :PackedScene

var skew_grain = 10.0
var input_dir :Vector2
var movement_state :Movement_State = Movement_State.IDLE
var shoot_state :Shoot_State = Shoot_State.IDLE
var bullet_time :float = 0.0

func _physics_process(delta :float):
	velocity = lerp(velocity, input_dir * speed, smooth * delta)
	
	#var skew = lerp(cockpit_sprite.skew, input_dir.x*skew_grain, smooth*delta)
	cockpit_sprite.skew = lerp(cockpit_sprite.skew, input_dir.x * PI/15.0, 0.1)
	weapon_sprite.skew = lerp(cockpit_sprite.skew, input_dir.x * PI/15.0, 0.1)
	
	move_and_slide()
	manage_shoot(delta)


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
		bullet.global_position = target.global_position
		bullet.direction = (target.global_position - global_position).normalized()
		bullet.origin = target.global_position
		bullet_time = 0.0

func take_hit(power: int):
	life -= power
	print("player life=", life)
