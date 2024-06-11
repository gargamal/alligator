extends CanvasLayer
class_name Hud_Score


@export var text_color :Color = Color("ffffff") :set = set_text_color
@export var difficulty_name :String = "" :set = set_difficulty_name
@export var score :int = 0 :set = set_score


@onready var score_label = $score_cont/column/lines/Score_Label
@onready var difficulty_label = $score_cont/column/lines/Difficulty_Label
@onready var score_cont = $score_cont


func set_text_color(new_text_color :Color):
	text_color = new_text_color
	score_cont.modulate = text_color


func set_difficulty_name(new_difficulty_name :String):
	difficulty_name = new_difficulty_name
	difficulty_label.text = "Difficulty : " + difficulty_name


func set_score(new_score):
	score = new_score
	score_label.text = "Score : " + str("%05d" % score)


func init_hud(difficulty_level :App_Game.Type_Difficulty):
	match difficulty_level:
		App_Game.Type_Difficulty.EASY: 
			set_text_color(App_Game.EASY_COLOR)
			set_difficulty_name("Easy")
		App_Game.Type_Difficulty.MEDIUM:
			set_text_color(App_Game.MEDIUM_COLOR)
			set_difficulty_name("Medium")
		App_Game.Type_Difficulty.HARD:
			set_text_color(App_Game.HARD_COLOR)
			set_difficulty_name("Hard")
	
