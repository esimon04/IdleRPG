extends Control
class_name CharacterStats

@export var character : CharacterResource

#BattleStats
@export var healthLabel : Label
@export var damageLabel : Label
@export var attackSpeedLabel : Label
@export var dpsLabel : Label
@export var critLabel : Label

#attr
@export var charStr : Label
@export var charDex : Label
@export var charCon : Label
@export var charInt : Label
@export var charWis : Label
@export var attrPoints : Label

#buttons
@export var strBut : Button
@export var dexBut : Button
@export var conBut : Button
@export var intBut : Button
@export var wisBut : Button

var attrPointsLeft : int
var allocatedPoints : Dictionary  # Key: attr, Value: Quantity

func _ready() -> void:
	allocatedPoints[CharacterResource.Attribute.STR] = 0
	allocatedPoints[CharacterResource.Attribute.DEX] = 0
	allocatedPoints[CharacterResource.Attribute.CON] = 0
	allocatedPoints[CharacterResource.Attribute.INT] = 0
	allocatedPoints[CharacterResource.Attribute.WIS] = 0

func update_character(new_character: CharacterResource):
	if not new_character:
		print("ERROR: No character provided to CharStats!")
		return

	character = new_character
	
	character.character_changed.connect(_on_character_change)
	
	attrPointsLeft = character.attributePointsAvailable
	for attr in allocatedPoints:
		allocatedPoints[attr] = 0
		
	_update_attr_displays()
	_update_battle_stats()
	
func _update_battle_stats():
	healthLabel.text =      "HEALTH:   %d" %character.getHealth()
	damageLabel.text =      "DAMAGE:   %d - %d" %[character.getMinDamage(), character.getMaxDamage()]
	attackSpeedLabel.text = "SPEED :   %.2f" %character.calculateAttackRate()
	dpsLabel.text =         "DPS   :   %.2f" % character.calculateIdleDPS()
	critLabel.text =        "CRIT  :   %.2f" %character.calculateCritRate()
	
		
func _update_attr_displays():
	charStr.text = str(character.getAttribute(CharacterResource.Attribute.STR) + allocatedPoints[CharacterResource.Attribute.STR])
	charDex.text = str(character.getAttribute(CharacterResource.Attribute.DEX) + allocatedPoints[CharacterResource.Attribute.DEX])
	charCon.text = str(character.getAttribute(CharacterResource.Attribute.CON) + allocatedPoints[CharacterResource.Attribute.CON])
	charInt.text = str(character.getAttribute(CharacterResource.Attribute.INT) + allocatedPoints[CharacterResource.Attribute.INT])
	charWis.text = str(character.getAttribute(CharacterResource.Attribute.WIS) + allocatedPoints[CharacterResource.Attribute.WIS])
	
	attrPoints.text = str(attrPointsLeft)
	
	if attrPointsLeft == 0:
		strBut.disabled = 1
		dexBut.disabled = 1
		conBut.disabled = 1
		intBut.disabled = 1
		wisBut.disabled = 1
	else:
		strBut.disabled = 0
		dexBut.disabled = 0
		conBut.disabled = 0
		intBut.disabled = 0
		wisBut.disabled = 0

func _on_increase_str_button_down() -> void:
	if attrPointsLeft > 0:
		attrPointsLeft -= 1
		allocatedPoints[CharacterResource.Attribute.STR] += 1
		_update_attr_displays()
	pass # Replace with function body.


func _on_increase_dex_button_down() -> void:
	if attrPointsLeft > 0:
		attrPointsLeft -= 1
		allocatedPoints[CharacterResource.Attribute.DEX] += 1
		_update_attr_displays()
	pass # Replace with function body.


func _on_increase_con_button_down() -> void:
	if attrPointsLeft > 0:
		attrPointsLeft -= 1
		allocatedPoints[CharacterResource.Attribute.CON] += 1
		_update_attr_displays()
	pass # Replace with function body.


func _on_increase_int_button_down() -> void:
	if attrPointsLeft > 0:
		attrPointsLeft -= 1
		allocatedPoints[CharacterResource.Attribute.INT] += 1
		_update_attr_displays()
	pass # Replace with function body.


func _on_increase_wis_button_down() -> void:
	if attrPointsLeft > 0:
		attrPointsLeft -= 1
		allocatedPoints[CharacterResource.Attribute.WIS] += 1
		_update_attr_displays()
	pass # Replace with function body.




func _on_confirm_button_down() -> void:
	print("Confirming Stats")
	var usedPoints = 0
	for attr in allocatedPoints:
		usedPoints += allocatedPoints[attr]
		character.charAttributeDictionary[attr] += allocatedPoints[attr]
		allocatedPoints[attr] = 0
	character.attributePointsAvailable = attrPointsLeft
	character.character_changed.emit()
	_update_attr_displays()
	pass # Replace with function body.


func _on_undo_button_down() -> void:
	var refundedPoints = 0
	for attr in allocatedPoints:
		refundedPoints += allocatedPoints[attr]
		allocatedPoints[attr] = 0
		
	attrPointsLeft += refundedPoints
	_update_attr_displays()
	pass # Replace with function body.
	
func _on_character_change():
	_update_attr_displays()
	_update_battle_stats()
