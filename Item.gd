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
		"Sword1" : "res://ItemResources/Items/Weapons/Sword.tres"
	}
	return item_database
	
