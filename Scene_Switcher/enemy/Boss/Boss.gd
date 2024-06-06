extends Enemy
class_name Boss

@onready var sprite_2d = $Body_Sprite
@onready var tower_sprite = $Body_Sprite/Weapon_Sprite
@onready var insight_shoot = $Body_Sprite/Weapon_Sprite/RayCast2D
@onready var fire_sparkles_2 = $Body_Sprite/Missile_Sprite/fire_sparkles
@onready var target_2 = $Body_Sprite/Missile_Sprite/target
@onready var missile_sprite = $Body_Sprite/Missile_Sprite
@onready var dead_sprite = $Dead_Sprite

@export var missile_scene : PackedScene
@export var missile_cooldown :float = 5.0

signal i_am_dead_boss(my_self)

var tower_rotation_sens_right = false
var missile_time :float = 0.0

func _specific_ready():
	target = $Body_Sprite/Weapon_Sprite/target
	fire_sparkles = $Body_Sprite/Weapon_Sprite/fire_sparkles

func _physics_process(delta :float):
	if is_running:
		if is_alive:
			process_distance_can_shoot(delta)
			state_machine()
			var direction :Vector2 = process_direction()
			velocity = lerp(velocity, process_velocity(direction), smooth * delta)
			rotation_animation(delta, direction)
			fire(delta)
			fire_missile(delta)
			move_and_slide()
			
			previous_enemy_state = enemy_state

func rotation_animation(_delta :float, _direction :Vector2):
	if insight_shoot.is_colliding() and insight_shoot.get_collider() is Player:
		pass
	else :
		if tower_rotation_sens_right:
			tower_sprite.rotation -= deg_to_rad(0.5)
			if tower_sprite.rotation < deg_to_rad(-45):
				tower_rotation_sens_right = false
		else:
			tower_sprite.rotation += deg_to_rad(0.5)
			if tower_sprite.rotation > deg_to_rad(45):
				tower_rotation_sens_right = true

func state_machine():
	match enemy_state:
		Enemy_State.IDLE:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.MOVE_SIDE_LEFT, Enemy_State.MOVE_SIDE_RIGHT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
					enemy_state = Enemy_State.MOVE_DOWN
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT
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
		
		Enemy_State.MOVE_DOWN:
			if not must_move_down():
				enemy_state = choice_side_direction()
			elif must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif insight_shoot.is_colliding():
				enemy_state = Enemy_State.SHOOT

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

func fire(delta :float):
	bullet_time += delta
	if bullet_time > bullet_cooldown and enemy_state == Enemy_State.SHOOT:
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
		var missile = missile_scene.instantiate()
		world.add_child(missile)
		missile.exclude_body = self 
		missile.global_position = target_2.global_position
		missile.origin = target_2.global_position 
		missile.direction = (player.global_position - target_2.global_position).normalized()
		missile_time = 0.0
		animation_player.play("fire_right")


func death():
	if is_alive:
		sprite_2d.texture = dead_sprite.texture
		tower_sprite.visible = false
		missile_sprite.visible = false
		is_alive = false
		collision_mask = 4
		collision_layer = 32
		process_explosion()
		emit_signal("i_am_dead_boss")
