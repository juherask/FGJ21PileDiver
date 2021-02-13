extends KinematicBody2D

export var max_walk_speed = 10000
export var max_throw_strength = 250

const GRAVITY = 50000
const JUMP_BASE_STRENGTH = 100000
const MAX_JUMP = 0.15
const MOVEMENT_SPEED = 25000
const FLOOR_FRICTION = 15000
const FALL_MULTIPLIER = 1.5
const JUMP_MULTIPLIER = 5
const BASE_THROW_STRENGTH = 10
const ADDITIONAL_THROW_MULTIPLIER = 2.0
const UP = Vector2(0, -1)

var velocity = Vector2()
var was_on_floor = false
var jump_strength = 0.0
var can_throw = false
var is_player = true

# This is kept in case it is added back to the tree
#  remember to set it visible
var carried_tree_item:RigidBody2D = null

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
			was_on_floor = false
			jump_strength = MAX_JUMP
			velocity.y -= JUMP_BASE_STRENGTH*jump_strength
			print("JUMP")
			jump_strength = 0.0
		if Input.is_action_pressed("dropDown"):
			self.position = Vector2(self.position.x, self.position.y + 2)
		
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

	elif $PlayerSprite.animation!="yeet":
		if velocity.x == 0:
			$PlayerSprite.play("idle")
		else:
			$PlayerSprite.play("walk")
		if was_on_floor == false:
			$PlayerSprite.play("jump")
	$PlayerSprite.playing = true

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if carried_tree_item!=null and can_throw:
			throw_carried_item()
			$PlayerSprite.play("yeet", true)

func _reset_carried_item():
	$CarriedItem.visible = false
	$CarriedItem.unique_item_id = 0
	$CarriedItem.item_type = ItemInfo.ItemType.NONE
	$CarriedItem.item_color = Color.transparent
	
func throw_carried_item(strength_multiplier=1.0):
	if not $CarriedItem or carried_tree_item==null:
		return
	
	# Assume player is parented to the world
	get_parent().add_child(carried_tree_item)
	_reset_carried_item()
	carried_tree_item.set_global_transform( $CarriedItem.get_global_transform() )
	
	# Launch it
	var mouse_position = get_global_mouse_position()
	var item_position = $CarriedItem.global_transform.get_origin()
	var mi_dist = mouse_position.distance_to(item_position)
	var mi_dir = -mouse_position.direction_to(item_position)
	
	carried_tree_item.linear_velocity = mi_dir*\
		min(max_throw_strength, (BASE_THROW_STRENGTH+
			mi_dist*ADDITIONAL_THROW_MULTIPLIER)*strength_multiplier)
		
	carried_tree_item = null
	
func _on_item_grabbed(item):
	if carried_tree_item!=null:
		throw_carried_item(0.2)
	
	# Note: we need to use Area2d for the carried item 
	#  because a rigid body would interfere with player movement.
	
	# Remove from the tree, add to the player.
	item.get_parent().remove_child(item)
	var item_sprite = item.get_node("ItemSprite")
	$CarriedItem/Sprite.texture = item_sprite.texture
	$CarriedItem/Sprite.region_enabled = true
	$CarriedItem/Sprite.region_rect = item_sprite.region_rect
	$CarriedItem.visible = true
	
	# Carried Area2d item to match the picked up (hidden) item.
	$CarriedItem.unique_item_id = item.unique_item_id
	$CarriedItem.item_type = item.item_type
	$CarriedItem.item_color = item.item_color
	carried_tree_item = item
	
	can_throw = false
	$GrabTimer.start()

func _on_Customer_takes_item(item):
	if carried_tree_item!=null and \
	   carried_tree_item.unique_item_id == item.unique_item_id:
		$CarriedItem.visible = false
		carried_tree_item.queue_free()
		carried_tree_item = null

func _on_GrabTimer_timeout():
	can_throw = true

func _on_PlayerSprite_animation_finished():
	if $PlayerSprite.animation=="yeet":
		$PlayerSprite.play("idle")
