extends RigidBody2D
class_name Target

@onready var explosion = $Explosion
@onready var sprite_2d = $Sprite2D

@export var exclude_body :Node2D
@export var speed_shoot :float = 5.0
@export var smooth :float = 2.0
@export var player_pos :Vector2 :set = set_target
@export var power :int = 1
@export var origin :Vector2
@export var distance_max :float = 400.0
@export var direction = Vector2.ZERO

var player_touched :bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity :Vector2 = Vector2.ZERO
	velocity = direction * speed_shoot


func process_direction():
	direction = Vector2(0,1)

func set_target(new_player_pos):
	player_pos = new_player_pos


func _on_body_entered(body):
	if body is Player:
		player_touched = true
	pass
