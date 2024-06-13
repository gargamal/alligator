extends CanvasLayer
class_name Menu_See_Score


@onready var lines = $cont/columns/lines/cont_score/scoreboard/cont/lines
@onready var one_line = $base_node/one_line


signal menu_main_became_visible


func _ready():
	var all_score :Array = App_Game.get_all_score()
	
	var idx :int = 0
	for one_score in all_score:
		var new_line :HBoxContainer = one_line.duplicate()
		lines.add_child(new_line)
		new_line.visible = true
		
		new_line.get_node("player_name").text = one_score.player_name
		new_line.get_node("score").text = str("%05d" % one_score.score)
		new_line.get_node("difficulty_level").text = screen_difficulty_level(int(one_score.difficulty))
		new_line.get_node("date").text = one_score.date
		new_line.modulate = color_difficulty_level(int(one_score.difficulty))
		idx +=1
		if idx >= 10:
			break


func color_difficulty_level(difficulty :App_Game.Type_Difficulty) -> Color:
	var color_difficulty :Color = Color.WHITE 
	match difficulty:
		App_Game.Type_Difficulty.EASY: color_difficulty = App_Game.EASY_COLOR
		App_Game.Type_Difficulty.MEDIUM: color_difficulty = App_Game.MEDIUM_COLOR
		App_Game.Type_Difficulty.HARD: color_difficulty = App_Game.HARD_COLOR
	return color_difficulty


func screen_difficulty_level(difficulty :App_Game.Type_Difficulty) -> String:
	var str_difficulty_level :String = ""
	match difficulty:
		App_Game.Type_Difficulty.EASY: str_difficulty_level = "Easy" 
		App_Game.Type_Difficulty.MEDIUM: str_difficulty_level = "Medium"
		App_Game.Type_Difficulty.HARD: str_difficulty_level = "Hard"
	return str_difficulty_level


func _on_quit_button_pressed():
	visible = false
	emit_signal("menu_main_became_visible")
