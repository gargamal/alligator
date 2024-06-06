extends Node
class_name Mouse_Click

@onready var click_down = $click_down
@onready var click_up = $click_up


@export var is_playable :bool = true


func _input(event :InputEvent):
	if is_playable:
		if event.is_action_pressed("ui_click_left") or (event is InputEventJoypadButton and event.is_pressed() and event.button_index in [0, 3]):
			click_down.play()
		elif event.is_action_released("ui_click_left") or (event is InputEventJoypadButton and event.is_released() and event.button_index in [0, 3]):
			click_up.play()

