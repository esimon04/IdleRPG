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
		"Sword" : "res://ItemResources/Items/Gear/Area1Gear/Sword.tres",
		"Staff" : "res://ItemResources/Items/Gear/Area1Gear/Staff.tres",
		"Dagger" : "res://ItemResources/Items/Gear/Area1Gear/Dagger.tres",
		#Armor
		"Leather Armor" : "res://ItemResources/Items/Gear/Area1Gear/leather_chest1.tres",
		"Leather Helmet" : "res://ItemResources/Items/Gear/Area1Gear/leather_helm1.tres",
		"Leather Boots" : "res://ItemResources/Items/Gear/Area1Gear/leather_helm1.tres",
		"Cloth Armor" : "res://ItemResources/Items/Gear/Area1Gear/cloth_chest.tres",
		"Cloth Hat" : "res://ItemResources/Items/Gear/Area1Gear/cloth_helm.tres",
		"Cloth Boots" : "res://ItemResources/Items/Gear/Area1Gear/cloth_boots.tres",
		"Mail Armor" : "res://ItemResources/Items/Gear/Area1Gear/mail_chest.tres",
		"Mail Helmet" : "res://ItemResources/Items/Gear/Area1Gear/mail_helm.tres",
		"Mail Boots" : "res://ItemResources/Items/Gear/Area1Gear/mail_boots.tres",
		
		"Gold Ring" : "res://ItemResources/Items/Gear/Area1Gear/ring1.tres",
		
		#Chests
		"Goblin Chest" : "res://ItemResources/Items/Chests/GoblinChest.tres"
	}
	return item_database
	
