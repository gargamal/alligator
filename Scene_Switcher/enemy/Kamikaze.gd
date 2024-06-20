extends App_Enemy
class_name Kamikaze

const PIXEL_PER_METER :float = 160.0
const MIN_TIME_REF_BEEP_PER_METER :float = 0.07


@onready var animation_player_rotor = $Sprite2D/AnimationPlayer
@onready var cockpit_sprite = $Sprite2D/cockpit_sprite
@onready var weapon_sprite = $Sprite2D/weapon_sprite
@onready var shadow = $Sprite2D/shadow
@onready var sprite_2d = $Sprite2D
@onready var beep_proximty_sound = $beep_proximty_sound
@onready var bullet_impacts = $Bullet_Impacts
@onready var explosion_range = $Explosion_Range
@onready var nav_agent_2d = $NavigationAgent2D


@export var power = 20

var exploded :bool = false
var time_play_beep :float = 0.0
var time_ref_play_beep :float = 0.0

func _ready(): 
	_init_ready()


func death():
	super()
	explosion_range.collision_layer = 0
	explosion_range.collision_mask = 0
	animation_player_rotor.stop()
	nav_agent_2d.navigation_layers = 2
	nav_agent_2d.avoidance_layers = 2
	nav_agent_2d.avoidance_mask = 0
	z_index = 0
	var tween :Tween = get_tree().create_tween()
	tween.tween_method(set_shadow_postion, shadow.position, Vector2(-5.0, 5.0), 0.5).set_trans(Tween.TRANS_SINE)

func _specific_ready():
	target = $target
	fire_sparkles = $fire_sparkles

func set_shadow_postion(shadow_position :Vector2):
	shadow.position = shadow_position

func process_direction():
	var estimate_direction :Vector2 = Vector2.ZERO
	estimate_direction = (player.global_position - global_position).normalized()
	return estimate_direction

func rotation_animation(_delta :float, direction :Vector2):
	cockpit_sprite.skew = lerp(cockpit_sprite.skew, -direction.x * PI/15.0, 0.1)
	weapon_sprite.skew = lerp(cockpit_sprite.skew, -direction.x * PI/15.0, 0.1)
	shadow.skew = lerp(shadow.skew, -direction.x * PI/15.0, 0.1)

func _physics_process(delta :float):
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
		
		if nav_agent_2d.avoidance_enabled:
			nav_agent_2d.velocity = new_velocity
		else:
			_on_navigation_agent_2d_velocity_computed(new_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if is_alive and distance_player < App_Enemy.LENGHT_FOLLOW_PLAYER:
		velocity = lerp(velocity, safe_velocity, 0.25)
		move_and_slide()
	
	elif velocity != Vector2.ZERO:
		velocity = Vector2.ZERO
		move_and_slide()


func _process(delta):
	if is_running and is_alive:
		#super(delta)
		process_beep_proximity(delta)

func process_beep_proximity(delta):
	var distance :float = player.global_position.distance_to(global_position)
	if distance > 0.0:
		time_ref_play_beep = MIN_TIME_REF_BEEP_PER_METER / (exp(-distance / PIXEL_PER_METER) - 1.0)
		time_ref_play_beep = time_ref_play_beep if time_ref_play_beep > MIN_TIME_REF_BEEP_PER_METER else MIN_TIME_REF_BEEP_PER_METER 
	else:
		time_ref_play_beep =  MIN_TIME_REF_BEEP_PER_METER 
	time_ref_play_beep = distance / PIXEL_PER_METER * MIN_TIME_REF_BEEP_PER_METER
	time_play_beep += delta
	if time_play_beep > time_ref_play_beep:
		time_play_beep = 0
		beep_proximty_sound.play()

func state_machine():
	match enemy_state:
		Enemy_State.IDLE:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.MOVE_SIDE_LEFT, Enemy_State.MOVE_SIDE_RIGHT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
					enemy_state = Enemy_State.MOVE_DOWN
			else:
				enemy_state = choice_side_direction()
		
		Enemy_State.SHOOT:
			if must_move_up():
				enemy_state = Enemy_State.MOVE_UP
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
		
		Enemy_State.MOVE_UP:
			if not must_move_up():
				enemy_state = choice_side_direction()
			elif must_move_down():
				enemy_state = Enemy_State.MOVE_DOWN
		
		Enemy_State.MOVE_DOWN:
			if not must_move_down():
				enemy_state = choice_side_direction()
			elif must_move_up():
				enemy_state = Enemy_State.MOVE_UP

func choice_side_direction() -> Enemy_State:
	if left_wall.is_colliding():
		return Enemy_State.MOVE_SIDE_RIGHT
	elif right_wall.is_colliding():
		return Enemy_State.MOVE_SIDE_LEFT
	else:
		return Enemy_State.MOVE_SIDE_RIGHT if global_position.x < player.global_position.x else Enemy_State.MOVE_SIDE_LEFT

func must_move_up() -> bool:
	return global_position.y > player.global_position.y + 30

func must_move_down() -> bool:
	return global_position.y < player.global_position.y -20 and global_position.y - player.global_position.y > -max_distance_between_player

func _on_explosion_range_body_entered(body):
	if body is Player:
		death()
		bullet_impacts._on_impact()
		body.take_hit(power)
