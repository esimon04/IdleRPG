extends Control
class_name Tavern

#Primary UI.
@export var character_list : VBoxContainer  # Reference to UI container
@export var party_list : VBoxContainer
@export var partyView : PartyView
@export var characterManager : CharacterManager

var selected_character : CharacterResource

signal PartyChanged

func OpenTavern() -> void:
	print("Opened party manager")
	updateDisplays()
	characterManager.inventoryView.update_inventory_display()
	#partyPanel.show()
	pass # Replace with function body.

func _on_close_menu_button_down() -> void:
	#partyPanel.hide()
	var children = character_list.get_children()
	for child in children:
		child.free()
	children = party_list.get_children()
	for child in children:
		child.free()
		
	partyView.saveParty()
	self.hide()
	pass # Replace with function body.


func populate_character_list(characters: Array, party: Array):
	var children = character_list.get_children()
	for child in children:
		child.free()
	children = party_list.get_children()
	for child in children:
		child.free()
	
	for character in party:
		if character:
			var slot = preload("res://Scenes/CharacterSlot.tscn").instantiate()  # Create new instance
			slot.update_character(character)  # Assign character data
			slot.character_button.pressed.connect(_on_character_selected.bind(character,self,true))  # Connect selection event
			party_list.add_child(slot)  # Add to list
		
	for character in characters:
		if character:
			var slot = preload("res://Scenes/CharacterSlot.tscn").instantiate()  # Create new instance
			slot.update_character(character)  # Assign character data
			slot.character_button.pressed.connect(_on_character_selected.bind(character,self,false))  # Connect selection event
			character_list.add_child(slot)  # Add to list
		
func updateDisplays():
	populate_character_list(GameManager.player_data.playerCharacters, GameManager.player_data.idleBattleData.characters)
	
			
func _on_character_selected(character, bench_slot, inParty):
	# Player selects a character from the bench
	print("Selected Character From Bench %s " %character.name)
	if !inParty:
		partyView.selectedCharacterFromBench(character)
	
	characterManager._on_character_selected(character)

	


func _on_party_view_party_changed() -> void:
	populate_character_list(GameManager.player_data.playerCharacters, GameManager.player_data.idleBattleData.characters)
	PartyChanged.emit()
	pass # Replace with function body.
