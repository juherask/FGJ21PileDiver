extends NinePatchRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var sceneName = ""

# Called when the node enters the scene tree for the first time.

func _on_Queue_no_customers_left():
	visible=true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():	
	get_tree().change_scene("res://scenes/" + sceneName + ".tscn")
	pass # Replace with function body.
