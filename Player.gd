extends KinematicBody2D

const GRAVITY = 50000
const JUMP_BASE_STRENGTH = 75000
const MIN_JUMP = 0.2
const MAX_JUMP = 0.3
const MOVEMENT_SPEED = 25000
const FLOOR_FRICTION = 15000

var velocity = Vector2()
var was_on_floor = false

const UP = Vector2(0, -1)

var jump_strength = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("jump"):
		jump_strength = 0.0
		print("START")
	
	if Input.is_action_pressed("left"):
		velocity.x -= MOVEMENT_SPEED*delta
	elif Input.is_action_pressed("right"):
		velocity.x += MOVEMENT_SPEED*delta
	elif is_on_floor() and velocity.x!=0:
		velocity.x -= velocity.x/abs(velocity.x)*FLOOR_FRICTION*delta
		
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_pressed("jump"):
			jump_strength += delta
		if Input.is_action_just_released("jump"):
			jump_strength = min(MAX_JUMP, max(MIN_JUMP, jump_strength))
			print("JUMP ", jump_strength)
			velocity.y -= JUMP_BASE_STRENGTH*jump_strength
			jump_strength = 0.0
	
	if was_on_floor!=is_on_floor():
		was_on_floor=is_on_floor()
		if !is_on_floor():
			print("lost contact to the floor")
		
	
	else:
		velocity.y += delta*GRAVITY
		
	move_and_slide( velocity*delta, UP, false, 4, 5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
