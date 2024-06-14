extends Enemy
class_name Boss_2

@onready var tower_sprite = $mesh/tripod_sprite/turret_sprite
@onready var kamikaze_spawn = $mesh/body_sprite/Kamikaze_spawn

@export var kamikaze_scene : PackedScene
@export var kamikaze_cooldown :float = 5.0
@export var kamikaze_target_scene : PackedScene

signal i_am_dead_boss(my_self)
var kamikaze_time :float = 0.0

func _specific_ready():
	target = $mesh/weapon/Weapon_Sprite/target
	fire_sparkles = $mesh/weapon/Weapon_Sprite/fire_sparkles
	

func _physics_process(delta :float):
	if is_running and is_alive:
		process_distance_can_shoot(delta)
		state_machine()
		var direction :Vector2 = process_direction()
		velocity = lerp(velocity, process_velocity(direction), smooth * delta)
		fire(delta)
		launch_kamikaze(delta)
		move_and_slide()
		
		previous_enemy_state = enemy_state

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
		world.add_child(kamikaze)
		kamikaze.exclude_body = self 
		kamikaze.global_position = kamikaze_spawn.global_position
		
		kamikaze_time = 0.0
