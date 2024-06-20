extends App_Enemy
class_name Boss_2

@onready var tower_sprite = $mesh/tripod_sprite/turret_sprite
@onready var kamikaze_spawn = $mesh/body_sprite/Kamikaze_spawn
@onready var sprite_2d = $mesh
@onready var smoke_r_2 = $move_smoke/smoke_r2
@onready var smoke_l_2 = $move_smoke/smoke_l2

@export var kamikaze_scene : PackedScene
@export var kamikaze_cooldown :float = 5.0

signal i_am_dead_boss(my_self)
var kamikaze_time :float = 0.0

func _ready(): 
	_init_ready()


func _specific_ready():
	smoke_r = $move_smoke/smoke_r
	smoke_l = $move_smoke/smoke_l
	fire_sparkles = $mesh/tripod_sprite/turret_sprite/fire_sparkles
	target = $mesh/tripod_sprite/turret_sprite/target


func _physics_process(delta :float):
	if is_running and is_alive:
		process_distance_can_shoot(delta)
		state_machine()
		var direction :Vector2 = process_direction()
		velocity = lerp(velocity, process_velocity(direction), smooth * delta)
		rotation_animation(delta, direction)
		fire(delta)
		launch_kamikaze(delta)
		move_and_slide()
		
		previous_enemy_state = enemy_state

func rotation_animation(delta :float, direction :Vector2):
	super(delta, direction)
	sprite_2d.rotation = lerp_angle(sprite_2d.rotation, estimate_target_angle(direction), estimate_angle_smooth() * delta)
	collision.rotation = sprite_2d.rotation

func fire(delta :float):
	bullet_time += delta
	if bullet_time > bullet_cooldown and enemy_state == Enemy_State.SHOOT:
		fire_weapon.fire()
		var ammo = ammo_scene.instantiate()
		world.add_child(ammo)
		ammo.exclude_body = self 
		ammo.global_position = target.global_position
		ammo.origin = target.global_position 
		ammo.direction = (target.global_position - tower_sprite.global_position).normalized()
		bullet_time = 0.0
		animation_player.play("fire_basis")

func launch_kamikaze(delta :float):
	kamikaze_time += delta
	if kamikaze_time > kamikaze_cooldown :
		var kamikaze = kamikaze_scene.instantiate()
		kamikaze.player = player
		kamikaze.connect("i_am_ready_enemy", _on_kamikaze_is_ready)
		world.add_child(kamikaze)
		kamikaze.global_position = kamikaze_spawn.global_position
		
		kamikaze_time = 0.0


func death():
	if is_alive:
		emit_signal("i_am_dead_boss", self)
		smoke_r_2.emitting = false
		smoke_l_2.emitting = false
	super()


func _on_kamikaze_is_ready(kamikaze :Kamikaze):
	kamikaze.is_running = true
