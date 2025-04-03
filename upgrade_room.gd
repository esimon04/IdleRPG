extends Control
class_name UpgradeRoom

@export var item : Equipment

@export var texture : TextureRect
@export var nameLabel : Label
@export var potentialLabel : Label
@export var modifierList : VBoxContainer


func _ready() -> void:
	UpdateDisplay()

func SetItem(itemIn : Equipment):
	item = itemIn
	UpdateDisplay()
	
func UpdatePotential():
	potentialLabel.text = "%d Potential Remaining" %item.potential

func UpdateDisplay():
	var children = modifierList.get_children()
	for child in children:
		child.free()
		
	if item:
		UpdatePotential()
		texture.texture = item.sprite
		nameLabel.text = item.name
		for modifier in item.modifiers:
			var modifierSlot = preload("res://modifier_slot_container.tscn").instantiate()
			modifierSlot.upgradeButton.pressed.connect(_on_upgrade_modifier.bind(modifier, modifierSlot))
			modifierSlot.SetModifier(modifier)
			modifierList.add_child(modifierSlot)  # Add to list


func _on_inventory_item_selected(slot: Variant) -> void:
	if slot.item is Equipment:
		SetItem(slot.item)
	pass # Replace with function body.

func _on_upgrade_modifier(mod : ModifierResource, slot) -> void:
	var rng = RandomNumberGenerator.new()
	if item.potential > 0:
		item.potential -= rng.randi_range(1,5)
		if item.potential < 0:
			item.potential = 0
		UpdatePotential()
		mod.UpgradeModifier()
		slot.UpdateDisplay()
	print("Upgrade button pressed")
