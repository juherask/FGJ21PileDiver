extends Node2D

export var queue_length = 5
export var replenish_queue = false
export var queue_move_speed = 1.0
export var distance_to_the_door = 100.0
export var customer_spacing = 15.0

const customer_factory = preload("res://scenes/QueuingCustomer.tscn")

var leftmost_customer:Node2D = null
var leaving_customer:Node2D = null
var last_customer_has_left = false
var is_customer_at_desk = false

signal no_customers_left
signal queued_customer_at_the_desk
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(queue_length):
		var new_cusomer = customer_factory.instance()
		new_cusomer.position.x = distance_to_the_door+customer_spacing*i
		self.add_child(new_cusomer)
	
func _process(delta):		

	if leaving_customer!=null:
		if leaving_customer.position.x < distance_to_the_door:
			leaving_customer.position.x+=queue_move_speed
		else:
			if get_child_count()==1 and not last_customer_has_left:
				emit_signal("no_customers_left")
				last_customer_has_left = true
				
			# Reached the door
			remove_child(leaving_customer)
			leaving_customer.queue_free()
			leaving_customer = null
			
			if replenish_queue:
				var new_cusomer = customer_factory.instance()
				new_cusomer.position.x = distance_to_the_door
				self.add_child(new_cusomer)
				
	if get_child_count()==0:
		return
			
	var customers = get_children()
	customers.sort_custom(self, "queue_order_comparer")
	
	var prev_customer_x = 0
	var is_leftmost_customer = true
	for customer in customers:
		if customer == leaving_customer:
			continue
				
		if is_leftmost_customer:
			
			if customer.position.x>0:
				customer.position.x-=queue_move_speed
				customer.active_sprite.play("walk")
			else:
				customer.active_sprite.play("idle")
				
				if not is_customer_at_desk:
					# remove from queue and signal for the active customer node to take it
					emit_signal("queued_customer_at_the_desk")
					is_customer_at_desk = true
			leftmost_customer = customer
			is_leftmost_customer = false
		else:
			if abs(prev_customer_x-customer.position.x)>customer_spacing:
				customer.position.x-=queue_move_speed
				customer.active_sprite.play("walk")
			else:
				customer.active_sprite.play("idle")
		prev_customer_x = customer.position.x
		
func _on_ActiveCustomer_takes_item(item):
	if leftmost_customer == null:
		return # too early for this	
			
	is_customer_at_desk = false
	leaving_customer = leftmost_customer
	leaving_customer.active_sprite.flip_h = false
	leaving_customer.active_sprite.play("walk")
