extends Resource
class_name CharacterResource

@export var name: String
@export var sprite: Texture
@export var health: int
@export var damage: int
@export var attackRate : float
@export var healing : float
@export var level : int

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

@export var attributePointsAvailable : int

signal character_changed #Signal to tell other nodes to update visuals about a character

func _init(_name: String = "Unknown", _level: int = 1, _sprite: Texture2D = null, _damage: int = 1, _health:int = 10, _healing : float = 1, _attackrate = 1):
	print("Character resource init called")
	name = _name
	level = _level
	attackRate = _attackrate
	sprite = _sprite
	damage = _damage
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
	
func calculateDamage() -> int:
	if equippedWeapon:
		var rng = RandomNumberGenerator.new()
		var baseDamage = rng.randi_range(equippedWeapon.minDamage, equippedWeapon.maxDamage)
		var modifier = 0
		modifier = getAttribute(equippedWeapon.abilityType)
		return baseDamage + modifier
			
	else:
		return charAttributeDictionary[CharacterResource.Attribute.STR]
		
func calculateAttackRate() -> float:
	#TODO can modify this based on stats
	if equippedWeapon:
		return equippedWeapon.attackSpeed
	else:
		return 1;
		
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
		
static func calculateXpForNextLevel(level : int):
	#TODO figure out pattern for this
	return (1 * level) + 5
	

	
