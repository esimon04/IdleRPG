extends HBoxContainer
class_name ModifierUpgradeContainer

@export var modifierNameLabel : Label
@export var modifierLevelLabel : Label
@export var upgradeButton : Button
@export var modifier : ModifierResource

func _on_upgrade_button_button_down() -> void:
	#modifier.UpgradeModifier()
	#print("Upgraded Modifier to level %d" %modifier.modifierLevel)
	#UpdateDisplay()
	pass # Replace with function body.

func SetModifier(mod : ModifierResource):
	modifier = mod
	UpdateDisplay()
	
func UpdateDisplay():
	if modifier:
		modifierNameLabel.text = ModifierResource.modifier_to_string[modifier.type]
		modifierLevelLabel.text = str(modifier.modifierLevel)
