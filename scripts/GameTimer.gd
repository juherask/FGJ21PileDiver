extends Node2D

	
func _on_Timer_timeout():
	$Player/CanvasLayer/TheEndLabel/Timer/CanvasLayer/NinePatchRect.visible = true
	#Show level score
	#Open level end menu
		#level end menu changes level to next
	pass

func _on_Queue_no_customers_left():
	$Player/CanvasLayer/TheEndLabel.visible = true
	$Player/CanvasLayer/TheEndLabel/Timer.start()
	pass # Replace with function body.
	

func _on_NextLevel_pressed():		
	print(get_tree().current_scene().name())
	#get_tree().change_scene("res://scenes/Level1.tscn")
	pass # Replace with function body.
