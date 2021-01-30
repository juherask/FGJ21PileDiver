extends KinematicBody2D

const GRAVITY = 50000
const JUMP_BASE_STRENGTH = 100000
const MIN_JUMP = 0.2
const MAX_JUMP = 0.35
const MOVEMENT_SPEED = 25000
const FLOOR_FRICTION = 15000
const FALL_MULTIPLIER = 1.5

var max_walk_speed = 10000

var velocity = Vector2()
var was_on_floor = false

const UP = Vector2(0, -1)

var jump_strength = 0.0
# This is kept in case it is added back to the tree
#  remember to set it visible
var carried_tree_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("jump"):
		jump_strength = MIN_JUMP
		print("START")
	
	if Input.is_action_pressed("left"):
		if velocity.x > -max_walk_speed:
			velocity.x -= MOVEMENT_SPEED*delta
	elif Input.is_action_pressed("right"):
		if velocity.x < max_walk_speed:
			velocity.x += MOVEMENT_SPEED*delta
	elif is_on_floor() and velocity.x!=0:
		velocity.x -= velocity.x/abs(velocity.x)*FLOOR_FRICTION*delta
		
	if velocity.x<-200.0:
		$PlayerSprite.flip_h = true
		$PlayerSprite.playing = true
		$CarriedItem.position.x = -abs($CarriedItem.position.x)
	elif velocity.x>200.0:
		$PlayerSprite.flip_h = false
		$PlayerSprite.playing = true
		$CarriedItem.position.x = abs($CarriedItem.position.x)
	else:
		velocity.x = 0.0
		$PlayerSprite.playing = false
	
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_pressed("jump"):
			jump_strength += delta
		if Input.is_action_just_released("jump"):
			jump_strength = min(MAX_JUMP, jump_strength)
			print("JUMP ", jump_strength)
			velocity.y -= JUMP_BASE_STRENGTH*jump_strength
			jump_strength = 0.0
	
	if was_on_floor!=is_on_floor():
		was_on_floor=is_on_floor()
		if !is_on_floor():
			print("lost contact to the floor")
		
	
	else:
		velocity.y += delta*GRAVITY*FALL_MULTIPLIER
		
	move_and_slide( velocity*delta, UP, false, 4, 5.0)

func throw_carried_item():
	if not $CarriedItem:
		return
		
	#TODO: Throw it away
	pass
	
	carried_tree_item=null

func _on_item_grabbed(item):
	if carried_tree_item!=null:
		throw_carried_item()
		
	# We need to use Area2d because rigid body
	#  would interfere with player movement.
		
	# Remove from the tree, add to the player.
	item.get_parent().remove_child(item)
	$CarriedItem/Sprite.texture = item.get_node("ItemSprite").texture
	$CarriedItem.visible = true
	
	# Carried Area2d item to match the picked up (hidden) item.
	$CarriedItem.item_id = item.item_id
	$CarriedItem.item_type = item.item_type
	$CarriedItem.item_color = item.item_color

	carried_tree_item = item
	

func _on_Customer_takes_item(item):
	if carried_tree_item!=null and \
	   carried_tree_item.item_id == item.item_id:
		$CarriedItem.visible = false
		carried_tree_item.queue_free()
		carried_tree_item = null
