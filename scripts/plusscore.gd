extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var score = 0

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


func _on_Customer_adds_score(value):
	show_score(value)
	
func show_score(value):
	score = value
	if value < 0:
		set("custom_colors/font_color", Color.red)
		text = str(score).pad_decimals(0)
	else:
		set("custom_colors/font_color", Color.green)
		text = "+" + str(score).pad_decimals(0)
	$DingTimer.start()
	get_parent().visible = true
	
func _on_DingTimer_timeout():
	get_parent().visible = false

func _on_ActiveCustomer_show_score(value):
	show_score(value)

func _on_ActiveCustomer_adds_score(value):
	show_score(value)
