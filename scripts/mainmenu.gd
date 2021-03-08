extends Control


func _on_StartGameBtn_pressed():
	get_tree().change_scene("res://scenes/level1.tscn")


func _on_HowToPlayBtn_pressed():
	get_tree().change_scene("res://scenes/howtoplay.tscn")

func _on_QuitGameBtn_pressed():
	get_tree().quit()
