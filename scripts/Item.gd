extends RigidBody2D

export(ItemInfo.ItemType) var item_type = ItemInfo.ItemType.BABY
export(Color) var item_color = Color.aqua
export var item_id = 0

const GRAB_DISTANCE = 50

signal item_grabbed

func _ready():
	item_id = get_instance_id()

func _input(event):
	if event is InputEventMouseButton or \
	   event is InputEventMouseMotion:
		var mouse_position = get_global_mouse_position()
		var item_position = global_transform.get_origin()
		var mi_d = mouse_position.distance_to(item_position)
		var player_position = get_node("/root/World/Player").global_transform.get_origin()
		var mp_d = mouse_position.distance_to(player_position)
		
		if mi_d<$ItemSprite.texture.get_height()/2.0 and \
		   mp_d<GRAB_DISTANCE:
			$HighlightSprite.visible = true
			
			if event is InputEventMouseButton:
				emit_signal("item_grabbed", self)
		else:
			$HighlightSprite.visible = false
