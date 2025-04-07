extends Resource
class_name Item

@export var max_stack : int
@export var name : String
@export var sprite : Texture
@export var description : String
@export var unique : bool
@export var id : String


static func LoadItemDatabase() -> Dictionary:
	var item_database = {
		#Currency
		"Gold" : "res://ItemResources/Currency/gold.tres",
		"Weak Soul" : "res://ItemResources/Currency/weakSoul.tres",
		
		#Equipment
		#Weapons
		"Sword" : "res://ItemResources/Items/Weapons/Sword.tres",
		"Staff" : "res://ItemResources/Items/Weapons/Staff.tres",
		#Armor
		"Leather Armor" : "res://ItemResources/Items/Gear/leather_chest1.tres",
		"Leather Helmet" : "res://ItemResources/Items/Gear/leather_helm1.tres",
		"Gold Ring" : "res://ItemResources/Items/Gear/ring1.tres",
		
		#Chests
		"Goblin Chest" : "res://ItemResources/Items/Chests/GoblinChest.tres"
	}
	return item_database
	
