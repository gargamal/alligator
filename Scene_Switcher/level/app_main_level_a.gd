extends Node2D
class_name App_Main_Level_A


@export var map_1 :Texture2D = load("res://Scene_Switcher/level/asset/map_city/map_city_1.png")


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
	CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM , CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM , 
	OPEN_LEFT__OPEN_RIGHT_OPEN_TOP__CLOSE_BOTTOM , OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM ,
	CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM 
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
const COLOR_OPEN_LEFT__OPEN_RIGHT_OPEN_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_OPEN],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_OPEN, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]
const COLOR_OPEN_LEFT__CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM = [
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
	[COLOR_OPEN, COLOR_UNDEFINE, COLOR_CLOSE],
	[COLOR_UNDEFINE, COLOR_CLOSE, COLOR_UNDEFINE],
]


var list_piece_map :Array = [
	{"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM, "all_color": COLOR_CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM},
	{"type" :Type_Map.CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM, "all_color": COLOR_CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM},
	{"type" :Type_Map.OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM, "all_color": COLOR_OPEN_LEFT__OPEN_RIGHT__OPEN_TOP__OPEN_BOTTOM},
	{"type" :Type_Map.OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM, "all_color": COLOR_OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__OPEN_BOTTOM},
	{"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM, "all_color": COLOR_CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM},
	{"type" :Type_Map.CLOSE_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM, "all_color": COLOR_CLOSE_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM},
	{"type" :Type_Map.OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM, "all_color": COLOR_OPEN_LEFT__OPEN_RIGHT__CLOSE_TOP__OPEN_BOTTOM},
	{"type" :Type_Map.OPEN_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM, "all_color": COLOR_OPEN_LEFT__CLOSE_RIGHT__CLOSE_TOP__OPEN_BOTTOM},
	{"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM , "all_color": COLOR_CLOSE_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM },
	{"type" :Type_Map.CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM , "all_color": COLOR_CLOSE_LEFT__OPEN_RIGHT__OPEN_TOP__CLOSE_BOTTOM },
	{"type" :Type_Map.OPEN_LEFT__OPEN_RIGHT_OPEN_TOP__CLOSE_BOTTOM , "all_color": COLOR_OPEN_LEFT__OPEN_RIGHT_OPEN_TOP__CLOSE_BOTTOM },
	{"type" :Type_Map.OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM , "all_color": COLOR_OPEN_LEFT__CLOSE_RIGHT__OPEN_TOP__CLOSE_BOTTOM },
	{"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM , "all_color": COLOR_OPEN_LEFT__CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM },
	{"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM , "all_color": COLOR_OPEN_LEFT__CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM },
	{"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM , "all_color": COLOR_OPEN_LEFT__CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM },
	{"type" :Type_Map.CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM , "all_color": COLOR_OPEN_LEFT__CLOSE_LEFT__CLOSE_RIGHT__CLOSE_TOP__CLOSE_BOTTOM }
]


var rng :RandomNumberGenerator = RandomNumberGenerator.new()
var texture_maps :Array = []


func _ready():
	if map_1: texture_maps.append(map_1)
	print(generate_array_map())


func generate_array_map() -> Array:
	var image_texture :Texture2D = texture_maps[rng.randi_range(0, texture_maps.size() - 1)]
	var array_map :Array = []
	@warning_ignore("integer_division")
	var nb_column :int = image_texture.get_width() / 3
	@warning_ignore("integer_division")
	var nb_line :int = image_texture.get_height() / 3
	
	var image :Image = image_texture.get_image()
	for idx_line in range(nb_line):
		var array_of_line :Array = []
		for idx_column in range(nb_column):
			var pixels :Array = [
				[image.get_pixel(idx_column * PIXEL_SIZE.y, idx_line * PIXEL_SIZE.x),  
				image.get_pixel(idx_column * PIXEL_SIZE.y + 1, idx_line * PIXEL_SIZE.x), 
				image.get_pixel(idx_column * PIXEL_SIZE.y + 2, idx_line * PIXEL_SIZE.x)],
				
				[image.get_pixel(idx_column * PIXEL_SIZE.y, idx_line * PIXEL_SIZE.x + 1),
				image.get_pixel(idx_column * PIXEL_SIZE.y + 1, idx_line * PIXEL_SIZE.x + 1),
				image.get_pixel(idx_column * PIXEL_SIZE.y + 2, idx_line * PIXEL_SIZE.x + 1)],
				
				[image.get_pixel(idx_column * PIXEL_SIZE.y, idx_line * PIXEL_SIZE.x + 2),
				image.get_pixel(idx_column * PIXEL_SIZE.y + 1, idx_line * PIXEL_SIZE.x + 2),
				image.get_pixel(idx_column * PIXEL_SIZE.y + 2, idx_line * PIXEL_SIZE.x + 2)]
			]
			var type_map :Type_Map = get_type_map(pixels)
			if type_map == Type_Map.ERROR:
				printerr("type_map==Type_Map.ERROR - pixels=", pixels)
				return []
			else:
				array_of_line.append(type_map)
		array_map.append(array_of_line)
	
	return array_map


func get_type_map(pixels :Array) -> Type_Map:
	for piece_map in list_piece_map:
		if is_same_pixels(pixels, piece_map):
			return piece_map.type
	return Type_Map.ERROR


func is_same_pixels(pixels :Array, piece_map :Dictionary) -> bool:
	print("****is_same_pixels=>pixels=", pixels)
	for idx in range(PIXEL_SIZE.x):
		for idy in range(PIXEL_SIZE.y):
			if idx == 1 and idy == 1: # ignor center
				continue
			
			print("idx=", idx, "-idy=", idy, "-pixels[idx][idy]=", pixels[idx][idy], "-piece_map.all_color[idx][idy]=", piece_map.all_color[idx][idy])
			if pixels[idx][idy] != piece_map.all_color[idx][idy]:
				print("   false")
				return false
	print("   true")
	return true
