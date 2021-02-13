extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$Player/CanvasLayer/TheEndLabel.visible = true
	#Show level score
	#Open level end menu
		#level end menu changes level to next
	pass


func _on_Queue_no_customers_left():
	$Player/CanvasLayer/TheEndLabel.visible = true
	pass # Replace with function body.
