extends Area2D
class_name Missile_Target

@onready var collision_shape_2d = $CollisionShape2D
@onready var explosion_death = $explosion_death

@export var power = 30

var missile_exploded :bool = false


func _on_area_entered(area):
	if area is Missile:
		area.free_bullet()
		
		check_if_player()


func check_if_player():
	missile_exploded = true
	collision_mask = 1
	collision_shape_2d.scale.x = 2
	collision_shape_2d.scale.y = 2
	explosion_death.play()


func _on_body_entered(body):
	if missile_exploded and body is Player :
		body.take_hit(power)


func _on_explosion_death_finished():
	queue_free()
