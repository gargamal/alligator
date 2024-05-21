extends CharacterBody2D
class_name Player


@export var speed :float = 500.0
@export var smooth :float = 2.0


var input_dir :Vector2


func _physics_process(delta):
	velocity = lerp(velocity, input_dir * speed, smooth * delta)
	move_and_slide()


func _input(_event):
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") \
			or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	elif Input.is_action_just_released("ui_down") or Input.is_action_just_released("ui_up") \
			or Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		input_dir = Vector2.ZERO
