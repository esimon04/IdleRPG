extends Control
class_name CharacterInformation

@export var character : CharacterResource
@export var characterSprite : TextureRect
@export var characterName : Label
@export var characterLevel : Label
@export var characterXpBar : ProgressBar

@export var weaponSlot : EquipmentSlot

var selectedItem : Item
var selectedEquipSlot : EquipmentSlot

func _ready() -> void:
	#weaponSlot.button.pressed.connect(_on_equipment_slot_clicked.bind(weaponSlot))
	weaponSlot.button.gui_input.connect(_on_equipment_slot_clicked.bind(weaponSlot))
	weaponSlot.equipmentType = Equipment.EquipmentType.WEAPON
	pass # Replace with function body.

func update_character(new_character: CharacterResource):
	if not new_character:
		print("ERROR: No character provided to PartySlot!")
		return

	character = new_character
	character.character_changed.connect(_on_char_changed)
	update_character_visuals()
	
	weaponSlot.set_item(character.equippedWeapon)
	
func update_character_visuals():
	characterSprite.texture = character.sprite if character.sprite else null
	characterName.text = character.name
	characterLevel.text = "Level: %d" % character.level
	characterXpBar.max_value = CharacterResource.calculateXpForNextLevel(character.level)
	characterXpBar.value = character.experience
	
func AttemptEquipItem(slot : EquipmentSlot, item : Item):
	print("Attempting to equip something")
	if item is Equipment:
		if slot.equipmentType == item.equipmentType:
			if slot.equipment:
				var removedItem = slot.equipment
				GameManager.player_data.playerInventory.add_item(removedItem,1)
				
			slot.set_item(item)
			GameManager.player_data.playerInventory.remove_item(item,1)

	else:
		print("Item %s Not Equipment - Cannot Equip" %item.name)
		
	selectedItem = null
	selectedEquipSlot = null
	UpdateCharacterEquipment()
	
func AttemptUnequipItem(slot: EquipmentSlot):
	if slot.equipment:
		var removedItem = slot.equipment
		GameManager.player_data.playerInventory.add_item(removedItem,1)
		slot.set_item(null)
	UpdateCharacterEquipment()
	
func UpdateCharacterEquipment():
	character.equippedWeapon = weaponSlot.equipment
	character.updateCharacterEquipment()
	character.character_changed.emit()
		

func _on_equipment_slot_clicked(event: InputEvent,slot : EquipmentSlot):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			selectedEquipSlot = slot
			if selectedItem:
					AttemptEquipItem(slot, selectedItem)
			pass
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			AttemptUnequipItem(slot)
			
	
func _on_inventory_item_selected(slot: InventorySlot) -> void:
	print("Characterinfo: selected invSlot with %s" %slot.item.name)
	selectedItem = slot.item;
	if selectedEquipSlot:
		AttemptEquipItem(selectedEquipSlot, selectedItem)
	pass # Replace with function body.
	
func _on_char_changed():
	update_character_visuals()
	
	
