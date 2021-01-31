extends Node2D

export var queue_move_speed = 1.0
export var distance_to_the_door = 100.0

var leftmost_customer:Node2D = null
var first_slot_free = true

var leaving_customer:Node2D = null

signal queued_customer_at_the_desk
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_update_leftmost_customer()

func _update_leftmost_customer():
	leftmost_customer = null
	var leftmost_x:float = 0.0
	for customer in get_children():
		if customer == leaving_customer:
			continue
		if leftmost_customer==null or customer.position.x<leftmost_x:
			leftmost_customer = customer
			leftmost_x = customer.position.x
		customer.active_sprite.play("walk")

func _process(delta):
	if leftmost_customer==null:
		return
		
	if leaving_customer!=null:
		if leaving_customer.position.x < distance_to_the_door:
			leaving_customer.position.x+=queue_move_speed
		else:
			remove_child(leaving_customer)
			leaving_customer.queue_free()
			leaving_customer = null
		
		
	if leftmost_customer.position.x > 0:
		for customer in get_children():
			customer.position.x-=queue_move_speed
	elif first_slot_free:
		first_slot_free = false
		for customer in get_children():
			if customer == leaving_customer:
				continue
			customer.active_sprite.play("idle")
		
		# remove from queue and signal for the active customer node to take it	
		emit_signal("queued_customer_at_the_desk")
		
func _on_ActiveCustomer_takes_item(item):
	first_slot_free = true
	#remove_child(leftmost_customer)
	leaving_customer = leftmost_customer
	leaving_customer.active_sprite.flip_h = false
	leaving_customer.active_sprite.play("walk")
	_update_leftmost_customer()
