extends Node
class_name PartyManager

@export var partyPanel : Control
@export var party : Party

@export var character_list : VBoxContainer  # Reference to UI container
@export var partSlot1 : PartySlot
@export var partSlot2 : PartySlot
@export var partSlot3 : PartySlot
@export var partSlot4 : PartySlot

var selected_character = null  # Store selected character
var selected_slot = null  # Track where it came from (bench or party slot)

func _ready():
	partyPanel.hide()  # Ensure the menu is hidden at start
	partSlot1.button.pressed.connect(_on_char_slot.bind(partSlot1))
	partSlot2.button.pressed.connect(_on_char_slot.bind(partSlot2))
	partSlot3.button.pressed.connect(_on_char_slot.bind(partSlot3))
	partSlot4.button.pressed.connect(_on_char_slot.bind(partSlot4))
	partSlot1.partyManager = self
	partSlot2.partyManager = self
	partSlot3.partyManager = self
	partSlot4.partyManager = self
	


func _on_open_party_manager_button_down() -> void:
	print("Opened party manager")
	updateDisplays()
	partyPanel.show()
	GameManager.pauseCombat()
	
	pass # Replace with function body.


func _on_close_menu_button_down() -> void:
	partyPanel.hide()
	var children = character_list.get_children()
	for child in children:
		child.free()
		
	saveParty()
	pass # Replace with function body.
	
func saveParty():
	#Update Party
	print("Saving party")
	if partSlot1.hasCharacter():
		print("SLOT 1 %s" %partSlot1.character.name)
	if partSlot2.hasCharacter():
		print("SLOT 2 %s" %partSlot2.character.name)
	if partSlot3.hasCharacter():
		print("SLOT 3 %s" %partSlot3.character.name)
	if partSlot4.hasCharacter():
		print("SLOT 4 %s" %partSlot4.character.name)
	GameManager.player_data.idleBattleData.characters[0] = partSlot1.character
	GameManager.player_data.idleBattleData.characters[1] = partSlot2.character
	GameManager.player_data.idleBattleData.characters[2] = partSlot3.character
	GameManager.player_data.idleBattleData.characters[3] = partSlot4.character
	party.setParty(GameManager.player_data.idleBattleData.characters)

func populate_character_list(characters: Array):
	var children = character_list.get_children()
	for child in children:
		child.free()
		
	for character in characters:
		var slot = preload("res://Scenes/CharacterSlot.tscn").instantiate()  # Create new instance
		slot.update_character(character)  # Assign character data
		slot.character_button.pressed.connect(_on_character_selected.bind(character,self))  # Connect selection event
		character_list.add_child(slot)  # Add to list
		
func populate_party_list(characters: Array):
	if characters[0]:
		partSlot1.update_character(characters[0])
	if characters[1]:
		partSlot2.update_character(characters[1])
	if characters[2]:
		partSlot3.update_character(characters[2])
	if characters[3]:
		partSlot4.update_character(characters[3])
	

func _on_character_selected(character, bench_slot):
	# Player selects a character from the bench
	selected_character = character
	print("Selected from bench:", character.name)
	# Reset selection
	selected_slot = null
	
func _on_char_slot(party_slot : PartySlot):	
	
	if selected_slot:
		if selected_character:
			#Slot and Character
			#Means need to check if the newSlot as a character, and if so swap.
			if party_slot.hasCharacter():
				swap_characters(selected_slot, party_slot)
			else:
				selected_slot.removeCharacter()
				party_slot.update_character(selected_character)
			#See if this works otherwise...
				
		else:
			#Slot and No Character
			#Shouldnt do shit
			var i = 1
	else:
		if selected_character:
			#Character but no slot
			#Means character is from bench
			#Check if char exists in new slot, if so they need to goto bench
			if party_slot.hasCharacter():
				var tempChar = party_slot.character
				party_slot.update_character(selected_character)
				
				characterRemoved(tempChar)
			else:
				#Isnt a character
				party_slot.update_character(selected_character)
				
			GameManager.player_data.playerCharacters.erase(selected_character)
		else:
			#NoSlot and NoCharacter
			#Shouldnt do shit
			selected_slot = party_slot;
			if party_slot.hasCharacter():
				selected_character = party_slot.character
			return
		
	
	# Reset selection
	selected_character = null
	selected_slot = null
	saveParty()
	updateDisplays()

func swap_characters(slot1, slot2):
	var char1 = slot1.character
	var char2 = slot2.character
	
	# Swap characters
	slot1.update_character(char2)
	slot2.update_character(char1)
	
func characterRemoved(character : CharacterResource):
	print("Removing Character")
	var idx = GameManager.player_data.idleBattleData.characters.find(character)
	GameManager.player_data.idleBattleData.characters[idx] = null
	GameManager.player_data.playerCharacters.append(character)
	saveParty()
	updateDisplays()
	
func updateDisplays():
	populate_character_list(GameManager.player_data.playerCharacters)
	populate_party_list(GameManager.player_data.idleBattleData.characters)
	
	
