extends Resource
class_name ModifierResource


enum ModifierType {STR, DEX, CON, INT, WIS, #Basic attributes
					ARMOR} #TODO expand


static var modifier_to_string = {
	ModifierType.STR: "Strength",
	ModifierType.DEX: "Dexterity",
	ModifierType.CON: "Constitution",
	ModifierType.INT: "Intelligence",
	ModifierType.WIS: "Wisdom",
	ModifierType.ARMOR: "Armor"
}

@export var type : ModifierType
@export var value : float
@export var modifierLevel : int #Numbers 1-10 changes based on itemlevel

#Main basis for modifierLevel to Value ratios
static func CalculateModifierValue(modifierLevel : int, modifier : ModifierType) -> float:
	var modifier2 = ModifierType.keys()[modifier]
	
	match modifier2:
		"STR", "DEX", "CON", "INT", "WIS":
			return modifierLevel
		"ARMOR":
			return modifierLevel * 2
	return 0

static func CalculateModifierLevel(itemLevel : int) -> int:
	var minVal = ceil((itemLevel + 20)/10) - 1
	var maxVal = ceil((itemLevel + 20)/10) + 1
	var rng = RandomNumberGenerator.new()
	return rng.randi_range(minVal, maxVal)
