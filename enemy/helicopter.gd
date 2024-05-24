extends Enemy
class_name Helicopter

@onready var animation_player = $Sprite2D/AnimationPlayer

func death():
	super()
	animation_player.stop()
