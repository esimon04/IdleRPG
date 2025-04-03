extends Item
class_name Equipment

enum EquipmentType {WEAPON, ARMOR, HELMET, RING}
enum RarityType {COMMON, UNCOMMON, RARE, EPIC, LEGENDARY, UNIQUE}

static var rarityTypeToColor = {
	RarityType.COMMON : Color(0.8, 0.8, 0.8),
	RarityType.UNCOMMON : Color(0.0, 1.0, 0.0),
	RarityType.RARE : Color(0.0, 0.5, 1.0),
	RarityType.EPIC : Color(0.6, 0.2, 0.8),
	RarityType.LEGENDARY : Color(1.0, 0.7, 0.2),
	RarityType.UNIQUE : Color(1.0, 0.5, 0.0)
	}

@export var equipmentType : EquipmentType
@export var modifiers: Array[ModifierResource] #These are guaranteed - think legendary items etc
@export var possibleModifiers : Array[PotentialEquipmentModifiers]
@export var numModifiers : int
@export var rarity : RarityType
@export var itemLevel : int
@export var potential : int

static func RollPotential() -> int:
	var rng = RandomNumberGenerator.new()
	return rng.randi_range(15, 25)

static func rollStats(arrayIn : Array[PotentialEquipmentModifiers], numModifiers, ilvl) -> Array:
	var modifiers = []
	for i in range(numModifiers):
		var rng = RandomNumberGenerator.new()
		var idx = rng.randi_range(0,arrayIn.size() - 1)
		var PotModifierToUse = arrayIn[idx]
		arrayIn.remove_at(idx)   #to ensure not same one twice
		var modifier = PotModifierToUse.modifier
		var modifierLevel = ModifierResource.CalculateModifierLevel(ilvl)
		var modifierVal = ModifierResource.CalculateModifierValue(modifierLevel, modifier) #rng.randi_range(PotModifierToUse.min,PotModifierToUse.max)
		var modifierResource = ModifierResource.new()
		modifierResource.type = modifier
		modifierResource.value = modifierVal
		modifierResource.modifierLevel = modifierLevel
		modifiers.append(modifierResource)
	return modifiers
	
static func getNumModifiers(rarity : RarityType) -> int:
	match rarity:
		RarityType.COMMON:
			return 0
		RarityType.UNCOMMON:
			return 1
		RarityType.RARE:
			return 2
		RarityType.EPIC:
			return 3
		RarityType.LEGENDARY:
			return 4
	print("SHOULDNT HAPPEN")
	return 1
	
static func GetTopDrops(ilvl : int, quantity : int) -> Array:
	var rarityList = []
	for idx in range(quantity):
		rarityList.append(RollRarity(ilvl))
	rarityList.sort_custom(func(a, b): return a > b)
	var returnVal =  rarityList.slice(0,min(25,quantity)) #25 can be changed
	print("Size of return %d" %returnVal.size())
	return returnVal

static func RollRarity(ilvl : int) -> RarityType:
	var rng = RandomNumberGenerator.new()
	var roll = rng.randf()
	var returnVal = RarityType.COMMON
	if ilvl < 10:
		if roll < .01:
			returnVal = RarityType.LEGENDARY
		elif roll < .05:
			returnVal = RarityType.EPIC
		elif roll < .1:
			returnVal = RarityType.RARE
		elif roll < .2:
			returnVal = RarityType.UNCOMMON
		else:
			returnVal = RarityType.COMMON
				
	elif ilvl < 20:
		if roll < .02:
			returnVal = RarityType.LEGENDARY
		elif roll < .07:
			returnVal = RarityType.EPIC
		elif roll < .15:
			returnVal = RarityType.RARE
		elif roll < .3:
			returnVal = RarityType.UNCOMMON
		else:
			returnVal = RarityType.COMMON
			
	elif ilvl < 30:
		if roll < .03:
			returnVal = RarityType.LEGENDARY
		elif roll < .09:
			returnVal = RarityType.EPIC
		elif roll < .18:
			returnVal = RarityType.RARE
		elif roll < .36:
			returnVal = RarityType.UNCOMMON
		else:
			returnVal = RarityType.COMMON
			
	elif ilvl < 40:
		if roll < .04:
			returnVal = RarityType.LEGENDARY
		elif roll < .11:
			returnVal = RarityType.EPIC
		elif roll < .21:
			returnVal = RarityType.RARE
		elif roll < .4:
			returnVal = RarityType.UNCOMMON
		else:
			returnVal = RarityType.COMMON
			
	else: 
		if roll < .05:
			returnVal = RarityType.LEGENDARY
		elif roll < .13:
			returnVal = RarityType.EPIC
		elif roll < .23:
			returnVal = RarityType.RARE
		elif roll < .45:
			returnVal = RarityType.UNCOMMON
		else:
			returnVal = RarityType.COMMON
	
	return returnVal
