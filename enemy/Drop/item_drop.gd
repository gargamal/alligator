extends Area2D
class_name ItemBox

enum Type_ItemBox { NONE, WEAPON, HEAL }

@onready var animation_player = $AnimationPlayer

@export_range(0.0, 1.0) var drop_weapon :float = 0.2

var rng = RandomNumberGenerator.new()
var type_itemBox :Type_ItemBox = Type_ItemBox.NONE

func _ready():
	if rng.randf_range(0.0, 1.0) <= drop_weapon:
		animation_player.play("item_drop_weapon")
		type_itemBox = Type_ItemBox.WEAPON
	else:
		animation_player.play("item_drop_heal")
		type_itemBox = Type_ItemBox.HEAL

func _on_body_entered(body):
	if body is Player:
		body.take_itembox(type_itemBox)
		queue_free()
