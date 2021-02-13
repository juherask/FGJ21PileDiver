extends Node2D

var active_sprite = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Choose randomly (hide others)
	var alt_sprites = []
	for child in get_children():
		if child is AnimatedSprite:
			alt_sprites.append(child)
			child.visible = false
			
	Rn.G.randomize()
	var selected_sprite_idx = Rn.G.randi_range(0, len(alt_sprites)-1)
	active_sprite = alt_sprites[selected_sprite_idx]
	active_sprite.visible = true
	
