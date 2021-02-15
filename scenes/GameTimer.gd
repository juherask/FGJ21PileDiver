extends Node2D

func _on_Timer_timeout():
	$Player/CanvasLayer/TheEndLabel.visible = true
	#Show level score
	#Open level end menu
		#level end menu changes level to next
	pass


func _on_Queue_no_customers_left():
	$Player/CanvasLayer/TheEndLabel.visible = true
	pass # Replace with function body.
