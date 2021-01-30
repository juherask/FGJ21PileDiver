extends Area2D

export(ItemInfo.ItemType) var requested_item_type = ItemInfo.ItemType.BABY
export(Color) var requested_item_color = Color.aqua # see ItemInfo for valid colors

signal takes_item

func _on_Customer_item_entered(potential_item):
	if "item_type" in potential_item and \
	   potential_item.item_type == requested_item_type and \
	   "item_color" in potential_item and \
	   potential_item.item_color == requested_item_color:

		# Right item. Client is happy
		# TODO: walk away
		# TODO: increase score depending on how long it took
		# TODO: Play a chime
		# TODO: Show a green +100 extra for a second

		get_node("/root/World/CanvasLayer/ScoreLabel").score+=100
		
		emit_signal("takes_item", potential_item)
		
		$CanvasLayer/SpeechBubble.visible = true
		
		$CanvasLayer/SpeechBubble/HideTimer.wait_time = 2
		$CanvasLayer/SpeechBubble/HideTimer.start()

func _on_Customer_area_entered(area):
	# Check for carried item
	_on_Customer_item_entered(area)

func _on_Customer_body_entered(body):
	# Check for thrown item	
	_on_Customer_item_entered(body)

func _on_HideTimer_timeout():
	$CanvasLayer/SpeechBubble.visible = false
