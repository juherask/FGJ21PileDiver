extends Node
enum ItemType{NONE, KEYS, MITTENS, HAT, SOCKS, WALLET, SCARF, PHONE, BABY, VEGETABLE}
const ITEM_NAMES = [
	"thingamabob",
	"key",
	"mitten",
	"hat",
	"sock",
	"wallet",
	"scarf",
	"phone",
	"baby",
	"vegetable",
]

const ALLOWED_ITEM_COLORS = [
	Color.aqua, 
	Color.pink,
	Color.lime,
	Color.blueviolet,
	Color.coral,
	Color.brown]
	
const ALLOWED_COLOR_NAMES = [
	"An blue ", 
	"A pink ",
	"A green ",
	"A violet ",
	"A orange ",
	"A brown "]

const SPRITE_RECOLOR_LIGHT = Color("#E392FE")
const SPRITE_RECOLOR_BASE = Color("#D357FE")
const SPRITE_RECOLOR_SHADOW = Color("#9929BD")
