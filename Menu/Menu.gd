extends Control

@onready var menu_principal = $Menu_Principal
@onready var menu_option = $Menu_Option

signal easy
signal medium
signal hard

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func clear():
	menu_option.visible = false
	menu_principal.visible = false

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://level/game_level.tscn")


func _on_option_button_pressed():
	clear()
	menu_option.visible = true


func _on_quit_button_pressed():
	get_tree().quit()


func _on_return_button_pressed():
	clear()
	menu_principal.visible = true



func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_easy_pressed():
	emit_signal("easy")


func _on_medium_pressed():
	emit_signal("medium")


func _on_hard_pressed():
	emit_signal("hard")
