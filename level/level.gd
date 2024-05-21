extends Node2D
class_name Level

const COLLISION_PLAYER :int = 1
const COLLISION_DECOR :int = 16


@onready var blocker = $blocker

signal spawn_new_level(my_self)
signal block_last_level(my_self)

@export var signal_next_level_has_sent :bool = false
@export var signal_previous_level_has_sent :bool = false
@export var block_player_is_done :bool = false
@export var previous :Level
@export var next :Level

func _on_other_level_body_entered(body):
	if not signal_next_level_has_sent and body is Player:
		signal_next_level_has_sent = true
		emit_signal("spawn_new_level", self)

func _on_block_last_level_body_entered(body):
	if not signal_previous_level_has_sent and body is Player:
		signal_previous_level_has_sent = true
		emit_signal("block_last_level", self)

func block_player():
	if not block_player_is_done:
		block_player_is_done = true
		blocker.collision_layer = COLLISION_DECOR
		blocker.collision_mask = COLLISION_PLAYER
