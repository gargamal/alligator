extends CanvasLayer
class_name Menu_In_Game


@export var title_name :String = "Pause" : set = set_title_name

@onready var game_over_label = $Game_Over/line/Game_Over_Label
@onready var mouse_sound = $mouse_sound


func _ready():
	mouse_sound.is_playable = false


func set_title_name(new_title_name :String):
	title_name = new_title_name
	game_over_label.text = title_name


func _on_visibility_changed():
	if is_inside_tree():
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE if visible else DisplayServer.MOUSE_MODE_HIDDEN)
		get_tree().paused = visible
		mouse_sound.is_playable = visible


func _on_button_retry_pressed():
	if is_inside_tree():
		get_tree().paused = false
		get_tree().reload_current_scene()


func _on_button_menu_pressed():
	if is_inside_tree():
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scene_Switcher/Menu/Menu.tscn")


func _on_button_resume_pressed():
	visible = false
