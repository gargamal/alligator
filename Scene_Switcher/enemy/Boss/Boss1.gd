extends Boss
class_name Boss_1

@onready var tower_sprite = $mesh/weapon/Weapon_Sprite

@onready var target_2 = $mesh/weapon/Missile_Sprite/target
@onready var missile_sprite = $mesh/weapon/Missile_Sprite
@onready var animation_tree = $AnimationTree


@export var missile_scene : PackedScene
@export var missile_cooldown :float = 5.0
@export var missile_target_scene : PackedScene

signal i_am_dead_boss(my_self)

var tower_rotation_sens_right = false
var missile_time :float = 0.0

func _specific_ready():
	target = $mesh/weapon/Weapon_Sprite/target
	fire_sparkles = $mesh/weapon/Weapon_Sprite/fire_sparkles
	animation_tree.active = true

func _physics_process(delta :float):
	if is_running and is_alive:
		process_distance_can_shoot(delta)
		state_machine()
		var direction :Vector2 = process_direction()
		velocity = lerp(velocity, process_velocity(direction), smooth * delta)
		fire(delta)
		fire_missile(delta)
		move_and_slide()
		
		previous_enemy_state = enemy_state

func _process(delta):
	super(delta)
	if is_running:
		animation_tree_player()
		weapon_animation()

func weapon_animation():
	if not insight_shoot.is_colliding():
		if tower_rotation_sens_right:
			tower_sprite.rotation -= deg_to_rad(0.5)
			if tower_sprite.rotation < deg_to_rad(-45.0):
				tower_rotation_sens_right = false
		else:
			tower_sprite.rotation += deg_to_rad(0.5)
			if tower_sprite.rotation > deg_to_rad(45.0):
				tower_rotation_sens_right = true

func animation_tree_player():
	animation_tree.set("parameters/conditions/death", not is_alive)
	
	if is_alive:
		var last_walk_factor :Vector2 = animation_tree.get("parameters/idle_walk/blend_position")
		var direction :Vector2 = process_direction()
		var new_walk_factor :Vector2 = direction * velocity.length()
		animation_tree.set("parameters/idle_walk/blend_position", lerp(last_walk_factor, new_walk_factor, .2))
		
	else:
		animation_tree.set("parameters/idle_walk/blend_position", Vector2.ZERO)

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

func fire_missile(delta :float):
	missile_time += delta
	if missile_time > missile_cooldown :
		
		fire_weapon.fire()
		var missile_target = missile_target_scene.instantiate()
		world.add_child(missile_target)
		missile_target.global_position = player.global_position
		
		var missile = missile_scene.instantiate()
		world.add_child(missile)
		missile.exclude_body = self 
		missile.global_position = target_2.global_position
		missile.origin = target_2.global_position 
		missile.set_fire((player.global_position - target_2.global_position).normalized(), player)
		
		missile_time = 0.0
		animation_player.play("fire_right")


