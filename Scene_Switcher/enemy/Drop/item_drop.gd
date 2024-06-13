extends Area2D
class_name ItemBox


enum Type_ItemBox { NONE, WEAPON, HEAL }


@onready var animation_player = $AnimationPlayer
@onready var heal_sound = $sound/Heal_Sound
@onready var weapon_sound = $sound/Weapon_Sound
@onready var circle_sprite = $Circle_Sprite
@onready var heal_sprite = $Heal_Sprite
@onready var weapon_sprite = $Weapon_Sprite


@export_range(0.0, 1.0) var drop_weapon :float = 0.2


var rng = RandomNumberGenerator.new()
var type_itemBox :Type_ItemBox = Type_ItemBox.NONE


func _ready():
	if rng.randf_range(0.0, 1.0) <= drop_weapon:
		animation_player.play("item_drop_weapon")
		type_itemBox = Type_ItemBox.WEAPON
	else:
		animation_player.play("item_drop_heal")
		type_itemBox = Type_ItemBox.HEAL


func _on_body_entered(body):
	if body is Player:
		collision_layer = 0
		collision_mask = 0
		animation_player.stop()
		circle_sprite.visible = false
		heal_sprite.visible = false
		weapon_sprite.visible = false
		
		body.take_itembox(type_itemBox)
		if type_itemBox == Type_ItemBox.WEAPON:
			weapon_sound.play()
		elif type_itemBox == Type_ItemBox.HEAL:
			heal_sound.play()
		else:
			queue_free()


func _on_sound_finished():
	queue_free()
