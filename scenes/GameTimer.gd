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


func _on_Button_pressed():
	if get_tree().current_scene().get_name() == "level1":
		get_tree().change_scene("res://scenes/level2.tscn")
	if get_tree().current_scene().get_name() == "level2":
		get_tree().change_scene("res://scenes/level3.tscn")
	if get_tree().current_scene().get_name() == "level3":
		get_tree().change_scene("res://scenes/mainmenu.tscn")
	pass # Replace with function body.
