extends Control
class_name CharacterManager

@export var charInfoPanel : CharacterInformation
@export var inventoryView : InventoryView
@export var charStatPanel : CharacterStats
@export var itemDisplay : ItemDisplay
var selected_character : CharacterResource

func _on_open_character_manager_button_down() -> void:
	print("Opening character manager")
	inventoryView.update_inventory_display()
	pass # Replace with function body.

func _on_character_selected(character):
	# Player selects a character from the bench
	selected_character = character
	charInfoPanel.update_character(selected_character)
	charStatPanel.update_character(selected_character)
	print("Selected from bench:", character.name)
	


func _on_inventory_item_selected(slot: InventorySlot) -> void:
	itemDisplay._update_item(slot.item)
	pass # Replace with function body.

func _on_character_information_equipment_selected(item: Equipment) -> void:
	itemDisplay._update_item(item)
	pass # Replace with function body.
