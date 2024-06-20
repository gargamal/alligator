extends CanvasLayer
class_name Save_Score_Player


@export var score :int
@export var difficulty :App_Game.Type_Difficulty


@onready var player_name = $cont/lines/player_name
@onready var button = $cont/lines/cont_btn/Button
@onready var mouse_sound = $mouse_sound


signal player_persisted


func _ready():
	mouse_sound.is_playable = false


func _process(_delta):
	if button and visible:
		button.disabled = player_name.text.length() == 0


func _on_button_pressed():
	if player_name.text.length() != 0:
		App_Game.persist_score_player(player_name.text, score, difficulty)
	emit_signal("player_persisted")
	visible = false


func _on_visibility_changed():
	if visible and not get_tree().paused:
		player_name.grab_focus()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		mouse_sound.is_playable = true
