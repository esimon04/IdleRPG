extends Item
class_name Equipment

enum EquipmentType {WEAPON}
@export var equipmentType : EquipmentType
@export var modifiers: Array[ModifierResource] #These are guaranteed - think legendary items etc
@export var possibleModifiers : Array[PotentialEquipmentModifiers]
@export var numModifiers : int

static func rollStats(arrayIn : Array[PotentialEquipmentModifiers], numModifiers) -> Array:
	var modifiers = []
	for i in range(numModifiers):
		var rng = RandomNumberGenerator.new()
		var idx = rng.randi_range(0,arrayIn.size() - 1)
		var PotModifierToUse = arrayIn[idx]
		var modifier = PotModifierToUse.modifier
		var modifierVal = rng.randi_range(PotModifierToUse.min,PotModifierToUse.max)
		var modifierResource = ModifierResource.new()
		modifierResource.type = modifier
		modifierResource.value = modifierVal
		modifiers.append(modifierResource)
	return modifiers
