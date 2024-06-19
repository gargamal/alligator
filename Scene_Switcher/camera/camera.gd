extends Camera2D
class_name Camera

const WIDTH :float = 1920.0
const OFFSET :int = 100

@export var player :Player

func _ready():
	global_position.x = WIDTH / 2.0

func _process(_delta):
	if player:
		global_position.y = player.global_position.y - OFFSET
		global_position.x = player.global_position.x - OFFSET
