extends Control

@export var panel : Control
@export var character_list : VBoxContainer  # Reference to UI container
@export var charInfoPanel : CharacterInformation
@export var inventoryView : InventoryView
@export var charStatPanel : CharacterStats
var selected_character : CharacterResource

func _ready() -> void:
	panel.hide()


func _on_open_character_manager_button_down() -> void:
	print("Opening character manager")
	populate_character_list()
	inventoryView.update_inventory_display()
	panel.show()
	pass # Replace with function body.


func _on_close_button_button_down() -> void:
	panel.hide()
	pass # Replace with function body.

func populate_character_list():
	var children = character_list.get_children()
	for child in children:
		child.free()	
		
	create_character_slot(GameManager.player_data.idleBattleData.characters[0])
	create_character_slot(GameManager.player_data.idleBattleData.characters[1])
	create_character_slot(GameManager.player_data.idleBattleData.characters[2])
	create_character_slot(GameManager.player_data.idleBattleData.characters[3])
		
	for character in GameManager.player_data.playerCharacters:
		create_character_slot(character)
			
func create_character_slot(character : CharacterResource):
	if is_instance_valid(character):
			var slot = preload("res://scenes/CharacterSlot.tscn").instantiate()  # Create new instance
			slot.update_character(character)  # Assign character data
			slot.character_button.pressed.connect(_on_character_selected.bind(character,self))  # Connect selection event
			character_list.add_child(slot)  # Add to list

func _on_character_selected(character, bench_slot):
	# Player selects a character from the bench
	selected_character = character
	charInfoPanel.update_character(selected_character)
	charStatPanel.update_character(selected_character)
	print("Selected from bench:", character.name)
	
