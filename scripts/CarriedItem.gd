extends Area2D

# If it looks like a duck, swims like a duck,
# and quacks like a duck, then it probably is a duck.
# (see Item.gd and Customer.gd)
var item_type = ItemInfo.ItemType.NONE
var item_color = Color.transparent # see ItemInfo for valid colors
var unique_item_id = 0
var carried_item = true
