extends Control
class_name ItemTooltip

@export var item : Item
@export var container : VBoxContainer
@export var nameLabel : Label
@export var descriptionLabel : Label

func update_item(_item : Item):
	item = _item
	update_display()
	
func update_display():
	nameLabel.text = item.name
	descriptionLabel.text = item.description
	
	if item is Equipment:
		
		nameLabel.add_theme_color_override("font_color", Equipment.rarityTypeToColor[item.rarity])
		
		if item.equipmentType == item.EquipmentType.WEAPON:
			var weaponDamageLabel = Label.new()
			weaponDamageLabel.text = "%d - %d %s Damage" %[item.minDamage, item.maxDamage, DamageTypes.type_to_string(item.damageType)]
			var weaponSpeedLabel = Label.new()
			weaponSpeedLabel.text = "Speed %.2f" %item.attackSpeed
			container.add_child(weaponDamageLabel)
			container.add_child(weaponSpeedLabel)
		
		var additionalModifiers = item.modifiers
		for modifier in additionalModifiers:
			var tempLabel = Label.new()
			tempLabel.text = "%s +%.2f" %[ModifierResource.modifier_to_string[modifier.type], modifier.value]
			container.add_child(tempLabel)
		  
	pass
