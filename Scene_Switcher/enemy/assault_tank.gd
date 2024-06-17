extends Enemy
class_name Assault_Tank

@onready var sprite_2d = $body_sprite
@onready var tower_sprite = $body_sprite/tower_sprite


func _specific_ready():
	target = $body_sprite/tower_sprite/target
	fire_sparkles = $body_sprite/tower_sprite/fire_sparkles
	smoke_r = $body_sprite/move_smoke/smoke_r
	smoke_l = $body_sprite/move_smoke/smoke_l

func _physics_process(delta):
	super(delta)
	tower_sprite.global_rotation = -PI

func rotation_animation(delta :float, direction :Vector2):
	super(delta, direction)
	sprite_2d.rotation = lerp_angle(sprite_2d.rotation, estimate_target_angle(direction), estimate_angle_smooth() * delta)
	collision.rotation = sprite_2d.rotation

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
