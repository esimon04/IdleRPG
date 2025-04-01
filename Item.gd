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
		"Gold" : "res://ItemResources/Currency/gold.tres",
		
		#Equipment
		#Weapons
		"Sword1" : "res://ItemResources/Items/Weapons/Sword.tres",
		"Staff1" : "res://ItemResources/Items/Weapons/Staff.tres",
		#Armor
		"LeatherChest" : "res://ItemResources/Items/Gear/leather_chest1.tres",
		"LeatherHelm" : "res://ItemResources/Items/Gear/leather_helm1.tres",
		"GoldRing" : "res://ItemResources/Items/Gear/ring1.tres",
		
		#Chests
		"GoblinChest" : "res://ItemResources/Items/Chests/GoblinChest.tres"
	}
	return item_database
	
