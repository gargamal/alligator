extends Area2D

@onready var collision_shape_2d = $CollisionShape2D

@export var power = 30

var missile_exploded :bool = false
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if missile_exploded:
		await get_tree().create_timer(0.1).timeout
		queue_free()


func _on_area_entered(area):
	if area is Missile:
		area.free_bullet()
		
		check_if_player()



func check_if_player():
	collision_mask = 1
	collision_shape_2d.scale.x = 2
	collision_shape_2d.scale.y = 2
	missile_exploded = true


func _on_body_entered(body):
	if missile_exploded:
		if body is Player :
			body.take_hit(power)
			queue_free()
