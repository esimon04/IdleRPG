extends Resource
class_name ModifierResource


enum ModifierType {STR, DEX, CON, INT, WIS} #TODO expand


static var modifier_to_string = {
	ModifierType.STR: "Strength",
	ModifierType.DEX: "Dexterity",
	ModifierType.CON: "Constitution",
	ModifierType.INT: "Intelligence",
	ModifierType.WIS: "Wisdom",
}

@export var type : ModifierType
@export var value : float
