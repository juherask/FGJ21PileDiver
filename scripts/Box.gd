extends Area2D

const item_scene = preload("res://scenes/Item.tscn")
var base_texture:Texture = preload("res://sprites/spritesheet_items.png")

export var item_type = ItemType.BABY
export var item_count = 5

const GRAB_DISTANCE = 50

const EXPLODE_ITEMS_PER_TIME_MAX = 3
const EXPLODE_ITEMS_DELAY_MIN = 0.01
const EXPLODE_ITEMS_DELAY_MAX = 0.1
const EXPLODE_VELOCITY_MIN = 100
const EXPLODE_VELOCITY_MAX = 500
const EXPLODE_DIR_MIN_DEG = -33
const EXPLODE_DIR_MAX_DEG = 33
const EXPLODE_SPIN_ANGULAR_VELOCITY_MIN = -100
const EXPLODE_SPIN_ANGULAR_VELOCITY_MAX = 100

var item_textures = []

var rng = RandomNumberGenerator.new()

func _ready():
	# initialize item sprites
	
		
	for i in range(item_count):
		var n_allowedc = len(ItemType.ALLOWED_ITEM_COLORS)
		var color = ItemType.ALLOWED_ITEM_COLORS[i%n_allowedc]
		
		# Load texture and recolor it
		# TODO: as an otpimization, only recolor the item of this type
		var texture_image = base_texture.get_data() # makes a copy!
		texture_image.lock()
		for y in base_texture.get_height():
			for x in base_texture.get_width():
				var pixelc = texture_image.get_pixel(x,y)
				if pixelc==ItemType.SPRITE_RECOLOR_LIGHT:
					texture_image.set_pixel(x,y,color.lightened(0.2))
				elif pixelc==ItemType.SPRITE_RECOLOR_BASE:
					texture_image.set_pixel(x,y,color)
				elif pixelc==ItemType.SPRITE_RECOLOR_SHADOW:
					texture_image.set_pixel(x,y,color.darkened(0.2))
		texture_image.unlock()
		
		var modified_texture = ImageTexture.new()
		modified_texture.create_from_image(texture_image)
		item_textures.append(modified_texture)
		
func open_box():
	$ExplodeTimer.start()
	
func _input(event):
	if event is InputEventMouseButton or \
	   event is InputEventMouseMotion:
		var mouse_position = get_global_mouse_position()
		var item_position = global_transform.get_origin()
		var mi_d = mouse_position.distance_to(item_position)
		var player_position = get_node("/root/World/Player").global_transform.get_origin()
		var mp_d = mouse_position.distance_to(player_position)
			
		var box_width = $BoxAnimatedSprite.frames.get_frame("open", 0).get_height()
		if mi_d<box_width and mp_d<GRAB_DISTANCE:
			$HighlightSprite.visible = true
			
			if event is InputEventMouseButton:
				open_box()
		else:
			$HighlightSprite.visible = false


func _on_ExplodeTimer_timeout():
	if len(item_textures)==0:
		return
	
	var max_tex = min(EXPLODE_ITEMS_PER_TIME_MAX, len(item_textures))
	var explode_this_time = rng.randi_range(1,max_tex)
	for i in range(explode_this_time):
		
		# Instantiate new items
		
		var item_texture = item_textures.pop_front()
		var item_node = item_scene.instance()
		var item_sprite = item_node.get_node("ItemSprite")
		
		item_sprite.texture = item_texture
		item_sprite.region_enabled = true
		
		item_sprite.region_rect = Rect2(
			item_texture.get_height()*(int(item_type)-1),
			0, 
			item_texture.get_height(),
			item_texture.get_height()
		)
		
		var launch_strength = rng.randf_range(
			EXPLODE_VELOCITY_MIN,
			EXPLODE_VELOCITY_MAX
		)
		var launch_vector = Vector2(0, launch_strength).rotated(
			deg2rad( rng.randf_range(EXPLODE_DIR_MIN_DEG,
			                         EXPLODE_DIR_MAX_DEG) )
		)
		var launch_spin = rng.randf_range(EXPLODE_SPIN_ANGULAR_VELOCITY_MIN,
			                              EXPLODE_SPIN_ANGULAR_VELOCITY_MAX) 
		item_node.linear_velocity = launch_vector
		item_node.angular_velocity = launch_spin
		
		# Add to the game
		item_node.global_position = self.global_position
		get_parent().add_child( item_node )

	# Queue up the next explosion (if there are textures left)
	if len(item_textures)>0:
		$ExplodeTimer.wait_time = rng.randf_range(EXPLODE_ITEMS_DELAY_MIN,
		                                          EXPLODE_ITEMS_DELAY_MAX)
		$ExplodeTimer.start()
	
	
		
		
	pass # Replace with function body.
