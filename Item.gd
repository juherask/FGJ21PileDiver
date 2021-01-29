extends RigidBody2D

const GRAB_DISTANCE = 100

signal item_grabbed

func _input(event):
	if event is InputEventMouseButton or \
	   event is InputEventMouseMotion:
		var mouse_position = get_global_mouse_position()
		var item_position = transform.get_origin()
		var mi_d = mouse_position.distance_to(item_position)
		
		if mi_d<$ItemSprite.texture.get_width()/2.0:
			$HighlightSprite.visible = true
			
			if event is InputEventMouseButton:
				var player_position = get_node("/root/World/Player").transform.get_origin()
				var mp_d = mouse_position.distance_to(player_position)
				if mp_d<GRAB_DISTANCE:
					emit_signal("item_grabbed", self)
		else:
			$HighlightSprite.visible = false
