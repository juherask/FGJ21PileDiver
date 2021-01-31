extends Area2D

const item_scene = preload("res://scenes/Item.tscn")

export(ItemInfo.ItemType) var item_type = ItemInfo.ItemType.BABY
export var item_count = 10

export var open_distance = 50

export var explode_items_at_a_time_max = 3
export var explode_items_random_delay_min = 0.01
export var explode_items_random_delay_max = 0.1
export var explode_random_velocity_min = 100
export var explode_random_velocity_max = 500
export var explode_random_dir_deg_min = -33
export var explode_random_dir_deg_max = 33
export var explode_random_spin_min = -100
export var explode_random_spin_max = 100

var rng = RandomNumberGenerator.new()

# The recolored textures for each item in the box is kept here.
var item_textures = []
var item_colors = []
var player = null

static func _recolor_items():
	var base_texture:Texture = preload("res://sprites/spritesheet_items.png")
	var recolored_textures = {}
	
	for color in ItemInfo.ALLOWED_ITEM_COLORS: 
		# Load texture and recolor it
		# TODO: as an otpimization, only recolor the item of this type!
		#       (for now all items are colored)
		var texture_image = base_texture.get_data() # makes a copy!
		texture_image.lock()
		for y in base_texture.get_height():
			for x in base_texture.get_width():
				var pixelc = texture_image.get_pixel(x,y)
				if pixelc==ItemInfo.SPRITE_RECOLOR_LIGHT:
					texture_image.set_pixel(x,y,color.lightened(0.2))
				elif pixelc==ItemInfo.SPRITE_RECOLOR_BASE:
					texture_image.set_pixel(x,y,color)
				elif pixelc==ItemInfo.SPRITE_RECOLOR_SHADOW:
					texture_image.set_pixel(x,y,color.darkened(0.2))
		texture_image.unlock()
		
		var modified_texture = ImageTexture.new()
		modified_texture.create_from_image(texture_image)
		recolored_textures[color] = modified_texture
		
	return recolored_textures

func _ready():
	player = get_node("/root/World/Player")
	
	# initialize item sprite textures (returns a dict keyed by color)
	var recolored_textures = _recolor_items()
	var color_key_list = recolored_textures.keys()
	for i in range(item_count):
		# Reuse colors as necessary
		var item_color =  color_key_list[i%len(color_key_list)]
		var matching_texture = recolored_textures[item_color]
		item_colors.append( item_color )
		item_textures.append( matching_texture )
		
func open_box():
	$ExplodeTimer.start()
	
func _input(event):
	if event is InputEventMouseButton or \
	   event is InputEventMouseMotion:
		var mouse_position = get_global_mouse_position()
		var item_position = global_transform.get_origin()
		var mi_d = mouse_position.distance_to(item_position)
		var player_position = player.global_transform.get_origin()
		var mp_d = mouse_position.distance_to(player_position)
			
		var box_width = $BoxAnimatedSprite.frames.get_frame("open", 0).get_height()
		if mi_d<box_width and mp_d<open_distance and len(item_textures)>0:
			$HighlightSprite.visible = true
			
			if event is InputEventMouseButton and event.pressed:
				$BoxAnimatedSprite.play()
				open_box()
		else:
			$HighlightSprite.visible = false


func _create_and_launch_item(from_item_texture, used_item_color):
	var item_node = item_scene.instance()
	item_node.item_type = item_type
	item_node.item_color = used_item_color
	
	var item_sprite = item_node.get_node("ItemSprite")
	item_sprite.texture = from_item_texture
	item_sprite.region_enabled = true
	
	item_sprite.region_rect = Rect2(
		from_item_texture.get_height()*(int(item_type)-1),
		0, 
		from_item_texture.get_height(),
		from_item_texture.get_height()
	)
	
	# Randomize the launch strength, spin, and direction
	
	var launch_strength = rng.randf_range(
		explode_random_velocity_min,
		explode_random_velocity_max
	)
	var launch_vector = Vector2(0, launch_strength).rotated(
		deg2rad( rng.randf_range(explode_random_dir_deg_min,
								 explode_random_dir_deg_max) )
	)
	var launch_spin = rng.randf_range(explode_random_spin_min,
									  explode_random_spin_max) 
	item_node.linear_velocity = launch_vector
	item_node.angular_velocity = launch_spin
	
	# Add the created item to the game
	item_node.global_position = self.global_position
	get_parent().add_child( item_node )
	# Allow player to grab the item
	item_node.connect("item_grabbed", player, "_on_item_grabbed")

func _on_ExplodeTimer_timeout():
	if len(item_textures)==0:
		return
	
	var max_tex = min(explode_items_at_a_time_max, len(item_textures))
	var explode_this_time = rng.randi_range(1,max_tex)
	for i in range(explode_this_time):
		# Instantiate new items based on topmost texture
		_create_and_launch_item( item_textures.pop_front(),
								 item_colors.pop_front() )
		
	# Queue up the next stage of the explosion (if there are textures left)
	if len(item_textures)>0:
		$ExplodeTimer.wait_time = rng.randf_range(explode_items_random_delay_min,
												  explode_items_random_delay_max)
		$ExplodeTimer.start()
