extends Area2D

enum ItemType {KEYS, PHONE, SOCK, WALLET, MITTEN, CAP, SCARF}

export var item_type = ItemType.KEYS
export var item_color = Color.aqua
		
func _on_Customer_item_entered(body):
	if "item_type" in body and body.item_type == item_type and \
	   "item_color" in body and body.item_color == item_color:
		# Right item. Client is happy
		# TODO: walk away
		# TODO: increase score depending on how long it took
		get_node("/root/World/ScoreLabel").score+=100
		# TODO: increase 
		
