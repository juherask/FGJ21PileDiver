extends Area2D

export var requested_item_type = ItemType.KEYS
export var requested_item_color = Color.aqua

signal takes_item

func _on_Customer_item_entered(potential_item):
	if "item_type" in potential_item and \
	   potential_item.item_type == requested_item_type and \
	   "item_color" in potential_item and \
	   potential_item.item_color == requested_item_color:
		
		# Right item. Client is happy
		# TODO: walk away
		# TODO: increase score depending on how long it took
		get_node("/root/World/CanvasLayer/ScoreLabel").score+=100
		# TODO: increase 
		
		emit_signal("takes_item", potential_item)
		$SpeechBubble.visible = true
	
func _on_Customer_area_entered(area):
	# Check for carried item
	_on_Customer_item_entered(area)
	
func _on_Customer_body_entered(body):
	# Check for thrown item	
	_on_Customer_item_entered(body)

func _on_HideTimer_timeout():
	$SpeechBubble.visible = false
