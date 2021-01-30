extends KinematicBody2D

const GRAVITY = 50000
const JUMP_BASE_STRENGTH = 100000
const MAX_JUMP = 0.15
const MOVEMENT_SPEED = 25000
const FLOOR_FRICTION = 15000
const FALL_MULTIPLIER = 1.5
const JUMP_MULTIPLIER = 5
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
		jump_strength = MAX_JUMP
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
		
		walk_animation()
			
		$CarriedItem.position.x = -abs($CarriedItem.position.x)
	elif velocity.x>200.0:
		$PlayerSprite.flip_h = false
		
		walk_animation()
		
		$CarriedItem.position.x = abs($CarriedItem.position.x)
	else:
		velocity.x = 0.0
		
		walk_animation()
	
	if is_on_floor():
		velocity.y = 0
		was_on_floor = true
		if Input.is_action_pressed("jump"):
			jump_strength = MAX_JUMP
			velocity.y -= JUMP_BASE_STRENGTH*jump_strength
			print("JUMP")
			jump_strength = 0.0
		
	if Input.is_action_just_released("jump"):
		print("FALL")
		velocity.y += delta*GRAVITY*JUMP_MULTIPLIER
	
	if !is_on_floor():
		velocity.y += delta*GRAVITY*FALL_MULTIPLIER
	
	move_and_slide( velocity*delta, UP, false, 4, 5.0)
	

func walk_animation():
	if carried_tree_item != null:
		if velocity.x == 0:
			$PlayerSprite.play("idlecarry")
		else:
			$PlayerSprite.play("carry")
		if was_on_floor == false:
			$PlayerSprite.play("jumpcarry")
	else:		
		if velocity.x == 0:
			$PlayerSprite.play("idle")
		else:
			$PlayerSprite.play("walk")
		if was_on_floor == false:
			$PlayerSprite.play("jump")
	$PlayerSprite.playing = true

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
	var item_sprite = item.get_node("ItemSprite")
	$CarriedItem/Sprite.texture = item_sprite.texture
	$CarriedItem/Sprite.region_enabled = true
	$CarriedItem/Sprite.region_rect = item_sprite.region_rect
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
