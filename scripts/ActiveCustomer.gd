extends Area2D

export(ItemInfo.ItemType) var requested_item_type = ItemInfo.ItemType.NONE
export(Color) var requested_item_color = Color.transparent # see ItemInfo for valid colors

signal adds_score
signal show_score
signal takes_item

<<<<<<< HEAD
var firstTime = true
=======
var customer_at_the_counter = false
>>>>>>> 544ecab54278a05223ef5dd524ead2a3f5edfc71

func _on_Customer_item_entered(potential_item):
	if not customer_at_the_counter:
		return
		
	if "item_type" in potential_item and \
	   "item_color" in potential_item:
		
		var score = 100;
		if potential_item.item_type == requested_item_type and \
		   potential_item.item_color == requested_item_color:

			# Right item. Client is happy
			# TODO: Play a chime
			
			score = $CanvasLayer/WaitTimer.time_left;
			emit_signal("adds_score", score)
			$CanvasLayer/WaitTimer.stop()
			
			var world_tree_idx = get_parent().remove_child(potential_item)
			emit_signal("takes_item", potential_item)
<<<<<<< HEAD
			firstTime = true
=======
			customer_at_the_counter = false
			
>>>>>>> 544ecab54278a05223ef5dd524ead2a3f5edfc71
			$CanvasLayer/SpeechBubble.visible = true
			$CanvasLayer/SpeechBubble/HideTimer.start()
		else:			
			if $CanvasLayer/SpeechBubble/HideTimer.time_left > 0:
				yield($CanvasLayer/SpeechBubble/HideTimer, "timeout")
			if $CanvasLayer/ItemBubble/HideTimer.time_left > 0:
				yield($CanvasLayer/ItemBubble/HideTimer,"timeout")
				
			if firstTime == false:
				score -= 10
				emit_signal("show_score", -10)
				emit_signal("adds_score", -10)
			firstTime = false
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
	customer_at_the_counter = true
	
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
	Rn.G.randomize()
	var chosen_item_idx = Rn.G.randi_range(0, len(available_item_colors)-1)
	if chosen_item_idx==-1:
		# no more items
		requested_item_color = Color.gray # should not be allowed
		
	requested_item_color = available_item_colors[chosen_item_idx]
	requested_item_type = available_item_types[chosen_item_idx]
	
	var color_idx = ItemInfo.ALLOWED_ITEM_COLORS.find(requested_item_color)


	if $CanvasLayer/SpeechBubble/HideTimer.time_left > 0:
		yield($CanvasLayer/SpeechBubble/HideTimer, "timeout")
	if $CanvasLayer/ItemBubble/HideTimer.time_left > 0:
		yield($CanvasLayer/ItemBubble/HideTimer,"timeout")
	firstTime = false
	$CanvasLayer/ItemBubble.visible = true
	$CanvasLayer/ItemBubble/VBoxContainer/Label.text = \
		ItemInfo.ALLOWED_COLOR_NAMES[color_idx]+\
		ItemInfo.ITEM_NAMES[int(requested_item_type)]
			
	$CanvasLayer/SpeechBubble/HideTimer.start()
<<<<<<< HEAD
	if	$CanvasLayer/WaitTimer.time_left <= 0:
		$CanvasLayer/WaitTimer.start()

func _on_Queue_queued_customer_at_the_desk():
	pass # Replace with function body.
=======
>>>>>>> 544ecab54278a05223ef5dd524ead2a3f5edfc71
