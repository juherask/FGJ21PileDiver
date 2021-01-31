extends Node
enum ItemType{NONE, KEYS, MITTENS, HAT, SOCKS, WALLET, SCARF, PHONE, BABY}
const ITEM_NAMES = [
	"thingamabob",
	"keys",
	"mittens",
	"hat",
	"socks",
	"wallet",
	"scarf",
	"phone",
	"baby",
]

const ALLOWED_ITEM_COLORS = [
	Color.aqua, 
	Color.pink,
	Color.lime,
	Color.blueviolet,
	Color.coral,
	Color.chocolate]
	
const ALLOWED_COLOR_NAMES = [
	"An aqua ", 
	"A pink ",
	"A lime ",
	"A violet ",
	"A coral ",
	"A brown "]

const SPRITE_RECOLOR_LIGHT = Color("#E392FE")
const SPRITE_RECOLOR_BASE = Color("#D357FE")
const SPRITE_RECOLOR_SHADOW = Color("#9929BD")
