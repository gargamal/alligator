extends Node2D
class_name App_Main_Level_A


###########################################################
#	o		#		o		#		o		#		o	
#.	X	.	#	.	X	o	#	o	X	o	#	o	X	.
#	o		#		o		#		o		#		o	
###########################################################
#	.		#		.		#		o		#		o	
#.	X	.	#	.	X	o	#	o	X	o	#	o	X	.
#	o		#		o		#		.		#		.	
###########################################################
#	o		#		o		#		.		#		.	
#.	X	.	#	.	X	o	#	o	X	o	#	o	X	.
#	.		#		.		#		o		#		o	
###########################################################
enum Type_Map {
	ERROR = -1,
	CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM, CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM, 
	OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM, OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM,
	CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM, CLOSE_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM, 
	OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM, OPEN_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM,
	CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM, CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM, 
	OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM, OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM,
	CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM, OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__CLOSE_BOTTOM
}

const COLOR_UNDEFINE :Color = Color("888888ff")
const COLOR_OPEN :Color = Color("ffffffff")
const COLOR_CLOSE :Color = Color("000000ff")
const PIXEL_SIZE :Vector2 =Vector2(3, 3)

const COLOR_CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_CLOSE, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
]
const COLOR_CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_CLOSE, COLOR_UNDEFINE, COLOR_OPEN],
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_OPEN],
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
]
const COLOR_CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
	[COLOR_CLOSE, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
]
const COLOR_CLOSE_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
	[COLOR_CLOSE, COLOR_UNDEFINE, COLOR_OPEN],
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_OPEN],
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
]
const COLOR_CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_CLOSE, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]
const COLOR_CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_CLOSE, COLOR_UNDEFINE, COLOR_OPEN],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_OPEN],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]
const COLOR_CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
	[COLOR_CLOSE, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_OPEN],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]

static var scene_close_left__close_right__open_top__open_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__open_bottom_1.tscn")
static var scene_close_left__close_right__open_top__open_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__open_bottom_2.tscn")
static var scene_close_left__close_right__open_top__open_bottom_3 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__open_bottom_3.tscn")
static var scene_close_left__close_right__open_top__open_bottom_4 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__open_bottom_4.tscn")
static var scene_close_left__close_right__open_top__open_bottom_5 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__open_bottom_5.tscn")
static var scene_close_left__close_right__open_top__open_bottom_6 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__open_bottom_6.tscn")
static var scene_close_left__open_right__open_top__open_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_close_left__open_right__open_top__open_bottom_1.tscn")
static var scene_close_left__open_right__open_top__open_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_close_left__open_right__open_top__open_bottom_2.tscn")
static var scene_close_left__open_right__open_top__open_bottom_3 = load("res://Scene_Switcher/level/normal_city/level_close_left__open_right__open_top__open_bottom_3.tscn")
static var scene_open_left__open_right__open_top__open_bottom = load("res://Scene_Switcher/level/normal_city/level_open_left__open_right__open_top__open_bottom.tscn")
static var scene_open_left__close_right__open_top__open_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_open_left__close_right__open_top__open_bottom_1.tscn")
static var scene_open_left__close_right__open_top__open_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_open_left__close_right__open_top__open_bottom_2.tscn")
static var scene_open_left__open_right__open_top__close_bottom = load("res://Scene_Switcher/level/normal_city/level_open_left__open_right__open_top__close_bottom.tscn")
static var scene_close_left__close_right__close_top__close_bottom = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__close_top__close_bottom.tscn")
static var scene_open_left__open_right__close_top__close_bottom = load("res://Scene_Switcher/level/normal_city/level_open_left__open_right__close_top__close_bottom.tscn")
static var scene_open_left__open_right__close_top__open_bottom = load("res://Scene_Switcher/level/normal_city/level_open_left__open_right__close_top__open_bottom.tscn")
static var scene_close_left__close_right__close_top__open_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__close_top__open_bottom_1.tscn")
static var scene_close_left__close_right__close_top__open_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__close_top__open_bottom_2.tscn")
static var scene_close_left__open_right__close_top__open_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_close_left__open_right__close_top__open_bottom_1.tscn")
static var scene_close_left__open_right__close_top__open_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_close_left__open_right__close_top__open_bottom_2.tscn")
static var scene_open_left__close_right__close_top__open_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_open_left__close_right__close_top__open_bottom_1.tscn")
static var scene_open_left__close_right__close_top__open_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_open_left__close_right__close_top__open_bottom_2.tscn")
static var scene_close_left__close_right__open_top__close_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__close_bottom_1.tscn")
static var scene_close_left__close_right__open_top__close_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__close_bottom_2.tscn")
static var scene_close_left__close_right__open_top__close_bottom_3 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__close_bottom_3.tscn")
static var scene_close_left__close_right__open_top__close_bottom_4 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__close_bottom_4.tscn")
static var scene_close_left__close_right__open_top__close_bottom_5 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__close_bottom_5.tscn")
static var scene_close_left__close_right__open_top__close_bottom_6 = load("res://Scene_Switcher/level/normal_city/level_close_left__close_right__open_top__close_bottom_6.tscn")
static var scene_close_left__open_right__open_top__close_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_close_left__open_right__open_top__close_bottom_1.tscn")
static var scene_close_left__open_right__open_top__close_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_close_left__open_right__open_top__close_bottom_2.tscn")
static var scene_open_left__close_right__open_top__close_bottom_1 = load("res://Scene_Switcher/level/normal_city/level_open_left__close_right__open_top__close_bottom_1.tscn")
static var scene_open_left__close_right__open_top__close_bottom_2 = load("res://Scene_Switcher/level/normal_city/level_open_left__close_right__open_top__close_bottom_2.tscn")


static var list_piece_map :Array = [
	{
		"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM, 
		"all_color": COLOR_CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM,
		"all_scene": [
			scene_close_left__close_right__open_top__open_bottom_1,
			scene_close_left__close_right__open_top__open_bottom_2,
			scene_close_left__close_right__open_top__open_bottom_3,
			scene_close_left__close_right__open_top__open_bottom_4,
			scene_close_left__close_right__open_top__open_bottom_5,
			scene_close_left__close_right__open_top__open_bottom_6
		]
	},
	{
		"type" :Type_Map.CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM, 
		"all_color": COLOR_CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM,
		"all_scene": [
			scene_close_left__open_right__open_top__open_bottom_1,
			scene_close_left__open_right__open_top__open_bottom_2,
			scene_close_left__open_right__open_top__open_bottom_3
		]
		},
	{
		"type" :Type_Map.OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM, 
		"all_color": COLOR_OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM,
		"all_scene": [scene_open_left__open_right__open_top__open_bottom]
	},
	{
		"type" :Type_Map.OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM, 
		"all_color": COLOR_OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM,
		"all_scene": [
			scene_open_left__close_right__open_top__open_bottom_1,
			scene_open_left__close_right__open_top__open_bottom_2
		]
	},
	{
		"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM, 
		"all_color": COLOR_CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM,
		"all_scene": [
			scene_close_left__close_right__close_top__open_bottom_1,
			scene_close_left__close_right__close_top__open_bottom_2
		]
	},
	{
		"type" :Type_Map.CLOSE_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM, 
		"all_color": COLOR_CLOSE_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM,
		"all_scene": [
			scene_close_left__open_right__close_top__open_bottom_1,
			scene_close_left__open_right__close_top__open_bottom_2
		]
	},
	{
		"type" :Type_Map.OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM, 
		"all_color": COLOR_OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM,
		"all_scene": [scene_open_left__open_right__close_top__open_bottom]
	},
	{
		"type" :Type_Map.OPEN_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM,
		"all_color": COLOR_OPEN_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM,
		"all_scene": [
			scene_open_left__close_right__close_top__open_bottom_1,
			scene_open_left__close_right__close_top__open_bottom_2
		]
	},
	{
		"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM ,
		"all_color": COLOR_CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM,
		"all_scene": [
			scene_close_left__close_right__open_top__close_bottom_1,
			scene_close_left__close_right__open_top__close_bottom_2,
			scene_close_left__close_right__open_top__close_bottom_3,
			scene_close_left__close_right__open_top__close_bottom_4,
			scene_close_left__close_right__open_top__close_bottom_5,
			scene_close_left__close_right__open_top__close_bottom_6
		]
	},
	{
		"type" :Type_Map.CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM ,
		"all_color": COLOR_CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM,
		"all_scene": [
			scene_close_left__open_right__open_top__close_bottom_1,
			scene_close_left__open_right__open_top__close_bottom_2
		]
	},
	{
		"type" :Type_Map.OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM ,
		"all_color": COLOR_OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM,
		"all_scene": [scene_open_left__open_right__open_top__close_bottom]
	},
	{
		"type" :Type_Map.OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM ,
		"all_color": COLOR_OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM,
		"all_scene": [
			scene_open_left__close_right__open_top__close_bottom_1,
			scene_open_left__close_right__open_top__close_bottom_2
		]
	},
	{
		"type" :Type_Map.OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__CLOSE_BOTTOM ,
		"all_color": COLOR_OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__CLOSE_BOTTOM,
		"all_scene": [scene_open_left__open_right__close_top__close_bottom]
	},
	{
		"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM ,
		"all_color": COLOR_CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM,
		"all_scene": [scene_close_left__close_right__close_top__close_bottom]
	}
]

static var rng :RandomNumberGenerator = RandomNumberGenerator.new()
static var texture_maps :Array = []
static var matrix_map :Array = []


static func generate_matrix_map() -> Array:
	var image_texture :Texture2D = texture_maps[rng.randi_range(0, texture_maps.size() - 1)]
	@warning_ignore("integer_division")
	var nb_column :int = image_texture.get_width() / 3
	@warning_ignore("integer_division")
	var nb_line :int = image_texture.get_height() / 3
	
	var image :Image = image_texture.get_image()
	for idx_line in range(nb_line):
		var array_of_line :Array = []
		for idx_column in range(nb_column):
			var pixels :Array = [
				[image.get_pixel(idx_column * int(PIXEL_SIZE.y), idx_line * int(PIXEL_SIZE.x)),  
				image.get_pixel(idx_column * int(PIXEL_SIZE.y) + 1, idx_line * int(PIXEL_SIZE.x)), 
				image.get_pixel(idx_column * int(PIXEL_SIZE.y) + 2, idx_line * int(PIXEL_SIZE.x))],
				
				[image.get_pixel(idx_column * int(PIXEL_SIZE.y), idx_line * int(PIXEL_SIZE.x) + 1),
				image.get_pixel(idx_column * int(PIXEL_SIZE.y) + 1, idx_line * int(PIXEL_SIZE.x) + 1),
				image.get_pixel(idx_column * int(PIXEL_SIZE.y) + 2, idx_line * int(PIXEL_SIZE.x) + 1)],
				
				[image.get_pixel(idx_column * int(PIXEL_SIZE.y), idx_line * int(PIXEL_SIZE.x) + 2),
				image.get_pixel(idx_column * int(PIXEL_SIZE.y) + 1, idx_line * int(PIXEL_SIZE.x) + 2),
				image.get_pixel(idx_column * int(PIXEL_SIZE.y) + 2, idx_line * int(PIXEL_SIZE.x) + 2)]
			]
			var type_map :Type_Map = get_type_map(pixels)
			if type_map == Type_Map.ERROR:
				printerr("type_map==Type_Map.ERROR - idx_line=", idx_line, " - idx_column=", idx_column, " - pixels=", pixels)
				return []
			else:
				array_of_line.append(type_map)
		matrix_map.append(array_of_line)
	
	#print("matrix result => ")
	#for idx in range(matrix_map.size()):
		#var line :String = ""
		#for idy in range(matrix_map[idx].size()):
			#line += str(matrix_map[idx][idy]) + "\t"
		#print(line)
	#print("Type_Map => ")
	#var truc :int = -1
	#for type_map in Type_Map.keys():
		#print("id=", truc, " / type_map=", type_map)
		#truc += 1
	return matrix_map


static func get_type_map(pixels :Array) -> Type_Map:
	for piece_map in list_piece_map:
		if is_same_pixels(pixels, piece_map):
			return piece_map.type
	return Type_Map.ERROR


static func is_same_pixels(pixels :Array, piece_map :Dictionary) -> bool:
	for idx in range(PIXEL_SIZE.x):
		for idy in range(PIXEL_SIZE.y):
			if idx == 1 and idy == 1: # ignor center
				continue
			
			if pixels[idx][idy] != piece_map.all_color[idx][idy]:
				return false
	return true


static func get_matrix_map() -> Array:
	if matrix_map.size() == 0:
		var map_1 :Texture2D = load("res://Scene_Switcher/level/asset/map_city/map_city_1.png")
		texture_maps.append(map_1)
		
		generate_matrix_map()
	return matrix_map


static func get_all_scene(type_map :Type_Map) -> Array:
	for piece_map in list_piece_map:
		if piece_map.type == type_map:
			return piece_map.all_scene
	
	return []
