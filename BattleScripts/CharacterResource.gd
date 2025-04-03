extends Resource
class_name CharacterResource

@export var name: String
@export var sprite: Texture
@export var health: int
@export var attackRate : float
@export var healing : float
@export var level : int

@export var damage_resistances: Dictionary = {
	DamageTypes.DamageType.PHYSICAL: 0.0, 
	DamageTypes.DamageType.FIRE: 0.0, 
	DamageTypes.DamageType.POISON: 0.0,
	DamageTypes.DamageType.LIGHTNING: 0.0, 
	DamageTypes.DamageType.HOLY: 0.0, 
	DamageTypes.DamageType.DARK: 0.0,
}

var critMultiplier : int = 2
var experience : float
var inParty: bool

#Character Stats
#Strength			STR		Strength Based weapon damage - Max weapon damage
#Dexterity			DEX		Dex based weapon damage - Crit chance
#Constitution		CON		Health - HP/s?
#Intenlligence		INT		IntBased weapon damage - affects skills
#Wisdom				WIS		HealingPower - affects skill cooldowns
enum Attribute {STR, DEX, CON, INT, WIS}
@export var charAttributeDictionary : Dictionary = {
	Attribute.STR : 0,
	Attribute.DEX : 0,
	Attribute.CON : 0,
	Attribute.INT : 0,
	Attribute.WIS : 0
}

@export var charAttributeEquipmentDictionary : Dictionary = {
	Attribute.STR : 0,
	Attribute.DEX : 0,
	Attribute.CON : 0,
	Attribute.INT : 0,
	Attribute.WIS : 0
}

#Equipment
@export var equippedWeapon : Weapon
@export var equippedArmor : Equipment
@export var equippedHelm : Equipment
@export var equippedRing : Equipment

@export var attributePointsAvailable : int

signal character_changed #Signal to tell other nodes to update visuals about a character

func _init(_name: String = "Unknown", _level: int = 1, _sprite: Texture2D = null,  _health:int = 10, _healing : float = 1, _attackrate = 1):
	print("Character resource init called")
	name = _name
	level = _level
	attackRate = _attackrate
	sprite = _sprite
	health = _health
	healing = _healing
	
	attributePointsAvailable = 0
	
	experience = 0
	inParty = false

func getExperience(expAmount : float):
	experience += expAmount
	if experience >= calculateXpForNextLevel(level): #TODO make this better
		level_up()
	
	character_changed.emit()
		
func level_up():
		print("Character %s Leveled up to %d" %[name,level])
		level += 1
		experience = experience - calculateXpForNextLevel(level)
		attributePointsAvailable += 1
		
func equipWeapon(weaponIn : Weapon):
	if equippedWeapon:
		GameManager.player_data.playerInventory.add_item(equippedWeapon, 1)
	equippedWeapon = weaponIn
	
func calculateDamageFlat() -> int:
	if equippedWeapon:
		var rng = RandomNumberGenerator.new()
		var baseDamage = rng.randi_range(equippedWeapon.minDamage, equippedWeapon.maxDamage) * (1 +rollCritChance())
		var modifier = 0
		modifier = getAttribute(equippedWeapon.abilityType)
		return baseDamage + modifier
	else:
		return getAttribute(Attribute.STR) 
		
func calculateDamage() -> Array:
	var damage_list = []
	var rng = RandomNumberGenerator.new()
	if equippedWeapon:
		var baseDamage = rng.randi_range(equippedWeapon.minDamage, equippedWeapon.maxDamage) * (1 + rollCritChance())
		var modifier = getAttribute(equippedWeapon.abilityType)
		var total_damage = baseDamage + modifier

		# Add base weapon damage type
		damage_list.append({ "type": equippedWeapon.damageType, "amount": total_damage })

		# If the weapon has additional elemental modifiers, add those
		#for mod in equippedWeapon.elementalModifiers:
		#	var extra_damage = rng.randi_range(mod.min, mod.max)
		#	damage_list.append({ "type": mod.damageType, "amount": extra_damage })

	else:
		# Default to Physical damage if no weapon is equipped
		damage_list.append({ "type": DamageTypes.DamageType.PHYSICAL, "amount": getAttribute(Attribute.STR) })

	return damage_list
		
func calculateAttackRate() -> float:
	#TODO can modify this based on stats
	if equippedWeapon:
		return equippedWeapon.attackSpeed
	else:
		return 1;
		
func calculateIdleDPS() -> float:
	var avgDmg = floor((getMinDamage() + getMaxDamage()) / 2)
	if equippedWeapon:
		avgDmg + getAttribute(equippedWeapon.abilityType)
	avgDmg =  avgDmg * (1 + calculateCritRate() * (critMultiplier - 1))
	avgDmg = avgDmg / calculateAttackRate()
	
	return avgDmg
		
func updateCharacterEquipment():
	#Clear
	charAttributeEquipmentDictionary[Attribute.STR] = 0
	charAttributeEquipmentDictionary[Attribute.DEX] = 0
	charAttributeEquipmentDictionary[Attribute.CON] = 0
	charAttributeEquipmentDictionary[Attribute.INT] = 0
	charAttributeEquipmentDictionary[Attribute.WIS] = 0
	
	#For each slot - update
	if equippedWeapon:
		updateAffectsFromGear(equippedWeapon)
	if equippedArmor:
		updateAffectsFromGear(equippedArmor)
	if equippedHelm:
		updateAffectsFromGear(equippedHelm)
	if equippedRing:
		updateAffectsFromGear(equippedRing)
		
func updateAffectsFromGear(gear : Equipment):
	var modifiers = gear.modifiers
	for modifier in modifiers:
		match modifier.type:
			ModifierResource.ModifierType.STR:
				charAttributeEquipmentDictionary[Attribute.STR] += floor(modifier.value)
			ModifierResource.ModifierType.DEX:
				charAttributeEquipmentDictionary[Attribute.DEX] += floor(modifier.value)
			ModifierResource.ModifierType.CON:
				charAttributeEquipmentDictionary[Attribute.CON] += floor(modifier.value)
			ModifierResource.ModifierType.INT:
				charAttributeEquipmentDictionary[Attribute.INT] += floor(modifier.value)
			ModifierResource.ModifierType.WIS:
				charAttributeEquipmentDictionary[Attribute.WIS] += floor(modifier.value)
				
func getAttribute(attr : Attribute) -> int:
	return charAttributeEquipmentDictionary[attr] + charAttributeDictionary[attr]
	
func getHealth() -> int:
	return 10 + 5 * getAttribute(Attribute.CON)
	
func getMinDamage() -> int:
	if equippedWeapon:
		return equippedWeapon.minDamage + getAttribute(equippedWeapon.abilityType)
	else:
		return 1
		
func getMaxDamage() -> int:
	if equippedWeapon:
		return equippedWeapon.maxDamage + getAttribute(equippedWeapon.abilityType)
	else:
		return getAttribute(Attribute.STR)
		
func getHealingPerSecond() -> float:
	return getAttribute(Attribute.WIS)
	
func calculateCritRate() -> float:
	if equippedWeapon:
		return equippedWeapon.critRate + (2 * log(getAttribute(Attribute.DEX))/100)
	else:
		return (2 * log(getAttribute(Attribute.DEX))/100)
		
func rollCritChance() -> int:
	var rng = RandomNumberGenerator.new()
	var roll = rng.randf()
	if roll <= calculateCritRate():
		print("CRIT CRIT CRIT")
		return 1
	return 0
	
		
static func calculateXpForNextLevel(level : int):
	#TODO figure out pattern for this
	return (1 * level) + 5
	

	
