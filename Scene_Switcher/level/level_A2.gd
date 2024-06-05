extends App_Main_Level_A
class_name Level_A2

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
		
		emit_signal("i_am_ready_level", self)
