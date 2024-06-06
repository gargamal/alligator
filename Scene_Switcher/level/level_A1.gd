extends App_Main_Level_A
class_name Level_A1

@onready var city_1_basic = $Sprites/city_1_basic
@onready var city_2_basic = $Sprites/city_2_basic
@onready var city_1_left = $Sprites/city_1_left
@onready var city_1_right = $Sprites/city_1_right
@onready var city_1_left_and_right = $Sprites/city_1_left_and_right
@onready var city_2_left = $Sprites/city_2_left
@onready var city_2_right = $Sprites/city_2_right
@onready var city_2_left_and_right = $Sprites/city_2_left_and_right
@onready var left_smokes = $Left_Smokes
@onready var right_smokes = $Right_Smokes

func _ready():
	blocker = get_node("blocker")
	spawn_point = get_node("spawn_point")
	if blocker and spawn_point:
		array_of_spawn = spawn_point.get_children()
		if assault_tank_scene:
			scene_of_spawn.append(assault_tank_scene)
		if helicopter_scene:
			scene_of_spawn.append(helicopter_scene)
		if jeep_scene:
			scene_of_spawn.append(jeep_scene)
		if artillery_scene:
			scene_of_spawn.append(artillery_scene)
		
		process_map()
		
		emit_signal("i_am_ready_level", self)

func clear_city():
	city_1_basic.visible = false
	city_1_left.visible = false
	city_1_left_and_right.visible = false
	city_1_right.visible = false
	city_2_basic.visible = false
	city_2_left.visible = false
	city_2_left_and_right.visible = false
	city_2_right.visible = false
	
	left_smokes.visible = false
	right_smokes.visible = false

func process_map():
	sprite_of_map.append(city_1_basic)
	sprite_of_map.append(city_1_left)
	sprite_of_map.append(city_1_right)
	sprite_of_map.append(city_1_left_and_right)
	sprite_of_map.append(city_2_basic)
	sprite_of_map.append(city_2_left)
	sprite_of_map.append(city_2_right)
	sprite_of_map.append(city_2_left_and_right)
	
	var idx_map:int = rng.randi_range(0, sprite_of_map.size() - 1)
	clear_city()
	sprite_of_map[idx_map].visible = true
	
	match idx_map:
		Type_City.CITY_1_BASIC, Type_City.CITY_2_BASIC: pass
		
		Type_City.CITY_1_LEFT, Type_City.CITY_2_LEFT:
			left_smokes.visible = true
		
		Type_City.CITY_1_RIGHT, Type_City.CITY_2_RIGHT:
			right_smokes.visible = true
		
		Type_City.CITY_1_LEFT_AND_RIGHT, Type_City.CITY_2_LEFT_AND_RIGHT:
			left_smokes.visible = true
			right_smokes.visible = true
