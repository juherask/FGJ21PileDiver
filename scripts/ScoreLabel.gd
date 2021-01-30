extends Label

var score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "%05d"%score
