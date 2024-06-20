extends CanvasLayer
class_name Hud_Extract_Map


const LIMIT_LEFT :float = 128.0
const LIMIT_RIGHT :float = 1792.0
const WEIGHT :float = 1920.0

@export var extract_point :Vector2
@export var player :Player


@onready var arrow_sprite = $arrow_sprite


func _process(_delta):
	var coord_x :float = extract_point.x - player.global_position.x + (WEIGHT / 2.0)
	coord_x = coord_x if coord_x < LIMIT_RIGHT else LIMIT_RIGHT
	coord_x = coord_x if coord_x > LIMIT_LEFT else LIMIT_LEFT
	arrow_sprite.rotation = (PI / 3.0 ) * (coord_x - WEIGHT / 2.0) / (WEIGHT / 2.0)
	arrow_sprite.position.x = coord_x
