extends Resource
class_name ModifierResource


enum ModifierType {STR, DEX, CON, INT, WIS, #Basic attributes
					ARMOR, FIRERES, NATURERES, LIGHTNINGRES, HOLYRES, DARKRES, #Resistances #TODO expand
					CRITCHANCE, ATTACKSPEED, CRITDMG,							#Weapon modifiers
					INCFIREDMG, INCNATUREDMG, INCLIGHTNINGDMG, INCHOLYDMG, INCDARKDMG,#increasedTypeDmg
					ADDEDFIREDMG, ADDEDNATUREDMG, ADDEDLIGHTNINGDMG, ADDEDHOLYDMG, ADDEDDARKDMG} #flat dmg of type

static var modifier_to_string = {
	ModifierType.STR: "Strength",
	ModifierType.DEX: "Dexterity",
	ModifierType.CON: "Constitution",
	ModifierType.INT: "Intelligence",
	ModifierType.WIS: "Wisdom",
	ModifierType.ARMOR: "Armor",
	ModifierType.FIRERES : "Fire Resistance", 
	ModifierType.NATURERES : "Nature Resistance", 
	ModifierType.LIGHTNINGRES : "Lightning Resistance", 
	ModifierType.HOLYRES : "Holy Resistance", 
	ModifierType.DARKRES : "Dark Resistance",
	ModifierType.CRITCHANCE : "Crit Chance", 
	ModifierType.ATTACKSPEED : "Attack Speed", 
	ModifierType.CRITDMG : "Crit Damage",							
	ModifierType.INCFIREDMG : "Increased Fire Damage", 
	ModifierType.INCNATUREDMG : "Increased Nature Damage", 
	ModifierType.INCLIGHTNINGDMG : "Increased Lightning Damage", 
	ModifierType.INCHOLYDMG : "Increased Holy Damage",
	ModifierType.INCDARKDMG : "Increased Dark Damage",
	ModifierType.ADDEDFIREDMG : "Added Fire Damage", 
	ModifierType.ADDEDNATUREDMG : "Added Nature Damage", 
	ModifierType.ADDEDLIGHTNINGDMG : "Added Lightning Damage", 
	ModifierType.ADDEDHOLYDMG : "Added Holy Damage", 
	ModifierType.ADDEDDARKDMG : "Added Dark Damage" 
}

@export var type : ModifierType
@export var value : float
@export var modifierLevel : int #Numbers 1-10 changes based on itemlevel

var weakSoul : Item = load("res://ItemResources/Currency/weakSoul.tres")
var soul : Item = load("res://ItemResources/Currency/soul.tres")

func UpgradeModifier():
	modifierLevel += 1
	value = CalculateModifierValue(modifierLevel, type)
	
func SoulTypeRequired() -> Item:
	match modifierLevel:
		1, 2, 3:
			return weakSoul
		4,5,6:
			return soul
	
	return weakSoul
	
func SoulCountRequired() -> int:
	
	return pow(3,((modifierLevel-1) % 3))

#Static functions
#Main basis for modifierLevel to Value ratios
static func CalculateModifierValue(modifierLevel : int, modifier) -> float:
	var modifier2 = ModifierType.keys()[modifier]
	var rng = RandomNumberGenerator.new()
	
	match modifier2:
		"STR", "DEX", "CON", "INT", "WIS": #[1 3] [4 6] [7 9] [10 12] [13 15] ...
			return (modifierLevel * 3) + rng.randi_range(1,3)
		"ARMOR":
			return modifierLevel * 2
		"FIRERES", "NATURERES", "LIGHTNINGRES", "HOLYRES", "DARKRES":
			return modifierLevel * 2
		"CRITCHANCE":
			return modifierLevel / 100
		"ATTACKSPEED":
			return modifierLevel * 5;
		"CRITDMG":
			return (modifierLevel * 2) / 100;
		"INCFIREDMG", "INCNATUREDMG", "INCLIGHTNINGDMG", "INCHOLYDMG", "INCDARKDMG":
			return (modifierLevel * 3) / 100
		"ADDEDFIREDMG", "ADDEDNATUREDMG", "ADDEDLIGHTNINGDMG", "ADDEDHOLYDMG", "ADDEDDARKDMG":
			return modifierLevel * 2
	return 0
	

static func CalculateModifierLevel(itemLevel : int) -> int:
	var minVal = itemLevel - 2
	if minVal < 1:
		minVal = 1
	var maxVal = itemLevel + 1
	var rng = RandomNumberGenerator.new()
	return rng.randi_range(minVal, maxVal)
	
