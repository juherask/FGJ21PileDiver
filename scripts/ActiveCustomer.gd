extends Area2D

export(ItemInfo.ItemType) var requested_item_type = ItemInfo.ItemType.BABY
export(Color) var requested_item_color = Color.aqua # see ItemInfo for valid colors

signal adds_score
signal takes_item

func _on_Customer_item_entered(potential_item):
	if "item_type" in potential_item and \
	   "item_color" in potential_item:
		
		if potential_item.item_type == requested_item_type and \
		   potential_item.item_color == requested_item_color:

			# Right item. Client is happy
			# TODO: Play a chime


			emit_signal("adds_score", 100)
			
			var world_tree_idx = get_parent().remove_child(potential_item)
			emit_signal("takes_item", potential_item)
			
			$CanvasLayer/SpeechBubble.visible = true
			$CanvasLayer/SpeechBubble/HideTimer.start()
		else:
			var color_idx = ItemInfo.ALLOWED_ITEM_COLORS.find(requested_item_color)
			if color_idx>=0:
				$CanvasLayer/ItemBubble.visible = true
				$CanvasLayer/ItemBubble/HideTimer.start()
				$CanvasLayer/ItemBubble/VBoxContainer/Label.text = \
					ItemInfo.ALLOWED_COLOR_NAMES[color_idx] +\
					ItemInfo.ITEM_NAMES[requested_item_type]
				

func _on_Customer_area_entered(area):
	# Check for carried item
	_on_Customer_item_entered(area)

func _on_Customer_body_entered(body):
	# Check for thrown item	
	_on_Customer_item_entered(body)

func _on_HideTimer_timeout():
	$CanvasLayer/SpeechBubble.visible = false
	$CanvasLayer/ItemBubble.visible = false

func _on_queued_customer_at_the_desk():
	# Get all items in the game (also from unopened boxes)
	var available_item_colors = []
	var available_item_types = []
	for potential_box_or_item in get_parent().get_children():
		if "is_box" in potential_box_or_item:
			var boxed_item_type = potential_box_or_item.item_type
			for i in range(len(potential_box_or_item.item_colors)):
				var boxed_item_color = potential_box_or_item.item_colors[i]
				available_item_colors.append(boxed_item_color)
				available_item_types.append(boxed_item_type)
		if "is_item" in potential_box_or_item:
			
			available_item_colors.append(potential_box_or_item.item_color)
			available_item_types.append(potential_box_or_item.item_type)
	
	# Choose one
	var chosen_item_idx = Rn.G.randi_range(0, len(available_item_colors)-1)
	if chosen_item_idx==-1:
		# no more items
		requested_item_color = Color.gray # should not be allowed
		
	requested_item_color = available_item_colors[chosen_item_idx]
	requested_item_type = available_item_types[chosen_item_idx]
	
	var color_idx = ItemInfo.ALLOWED_ITEM_COLORS.find(requested_item_color)
	
	$CanvasLayer/ItemBubble.visible = true
	$CanvasLayer/ItemBubble/VBoxContainer/Label.text = \
		ItemInfo.ALLOWED_COLOR_NAMES[color_idx]+\
		ItemInfo.ITEM_NAMES[int(requested_item_type)]
	$CanvasLayer/SpeechBubble/HideTimer.start()
	
