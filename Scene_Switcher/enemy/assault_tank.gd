extends App_Enemy
class_name Assault_Tank

@onready var sprite_2d = $body_sprite
@onready var tower_sprite = $body_sprite/tower_sprite


func _ready(): 
	_init_ready()


func _specific_ready():
	target = $body_sprite/tower_sprite/target
	fire_sparkles = $body_sprite/tower_sprite/fire_sparkles
	smoke_r = $body_sprite/move_smoke/smoke_r
	smoke_l = $body_sprite/move_smoke/smoke_l

func _physics_process(delta):
	distance_player = (player.global_position - global_position).length()
	if is_running and is_alive and distance_player < App_Enemy.LENGHT_FOLLOW_PLAYER:
		nav_agent_2d.target_position = player.global_position
		var next_pos :Vector2 = nav_agent_2d.get_next_path_position()
		if not next_pos.is_finite() or abs(next_pos.x) > 50000.0 or abs(next_pos.y) > 50000.0 :
			return
		
		var direction :Vector2
		if not nav_agent_2d.is_target_reachable() and velocity.length() < 0.1:
			direction = lerp(velocity.normalized(), player.global_position - global_position.normalized(), 0.25)
		else:
			direction = lerp(velocity.normalized(), (next_pos - global_position).normalized(), 0.25)
		direction = direction.normalized()
		
		var new_velocity :Vector2 = direction * speed
		sprite_2d.rotation = atan2(-direction.x, direction.y)
		collision_shape_2d.rotation = sprite_2d.rotation
		#tower_sprite.rotation = -PI
		
		#if nav_agent_2d.avoidance_enabled:
			#nav_agent_2d.velocity = new_velocity
		#else:
			#_on_navigation_agent_2d_velocity_computed(new_velocity)

func rotation_animation(delta :float, direction :Vector2):
	pass
	#super(delta, direction)
	#sprite_2d.rotation = lerp_angle(sprite_2d.rotation, estimate_target_angle(direction), estimate_angle_smooth() * delta)
	#collision.rotation = sprite_2d.rotation

func fire_anim():
	animation_player.play("fire_tank")

func fire(delta :float):
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
