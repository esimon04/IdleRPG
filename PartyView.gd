extends Control
class_name PartyView
#PartySlots
@export var partSlot1 : PartySlot
@export var partSlot2 : PartySlot
@export var partSlot3 : PartySlot
@export var partSlot4 : PartySlot

#PartyStats
@export var partyDpsLabel : Label
@export var partyHealthLabel : Label
@export var partyHealingLabel : Label

var characterSelectedFromBench : CharacterResource
var selectedPartySlot : PartySlot

signal partyChanged

func _ready():
	partSlot1.button.gui_input.connect(_on_party_slot_clicked.bind(partSlot1))
	partSlot2.button.gui_input.connect(_on_party_slot_clicked.bind(partSlot2))
	partSlot3.button.gui_input.connect(_on_party_slot_clicked.bind(partSlot3))
	partSlot4.button.gui_input.connect(_on_party_slot_clicked.bind(partSlot4))
	populate_party_list()
	UpdatePartyStats()
	
func characterRemoved(slot : PartySlot):
	print("Removing Character")
	var idx = GameManager.player_data.idleBattleData.characters.find(slot.character)
	GameManager.player_data.idleBattleData.characters[idx] = null
	GameManager.player_data.playerCharacters.append(slot.character)
	slot.removeCharacter()
	saveParty()
	populate_party_list()
	
	
func selectedCharacterFromBench(benchChar : CharacterResource):
	characterSelectedFromBench = benchChar
	if selectedPartySlot:
		MoveSelectedBenchToParty()
			
func PartySlotSelected(slot : PartySlot):
	print("SelectedPartySlot")
	if selectedPartySlot:
		SwapPartySpots(slot, selectedPartySlot)
		selectedPartySlot = null
		characterSelectedFromBench = null
	else:
		selectedPartySlot = slot
		if characterSelectedFromBench:
			MoveSelectedBenchToParty()
		
func MoveSelectedBenchToParty():
	#This means that a slot has previously been selected so the selectedBench char should go there
	if selectedPartySlot.hasCharacter():
		GameManager.player_data.playerCharacters.append(selectedPartySlot.character)
		selectedPartySlot.update_character(characterSelectedFromBench)
	else:
		selectedPartySlot.update_character(characterSelectedFromBench)
		
	GameManager.player_data.playerCharacters.erase(characterSelectedFromBench)
	saveParty()
	selectedPartySlot = null
	characterSelectedFromBench = null
	
func SwapPartySpots(slot1 : PartySlot, slot2: PartySlot):
	var char1 = slot1.character
	var char2 = slot2.character
	
	# Swap characters
	slot1.update_character(char2)
	slot2.update_character(char1)
	saveParty()
	

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
		
	GameManager.player_data.idleBattleData.SetPartySlot(partSlot1.character, 0)
	GameManager.player_data.idleBattleData.SetPartySlot(partSlot2.character, 1)
	GameManager.player_data.idleBattleData.SetPartySlot(partSlot3.character, 2)
	GameManager.player_data.idleBattleData.SetPartySlot(partSlot4.character, 3)
	partyChanged.emit()
	UpdatePartyStats()

func populate_party_list():
	var characters = GameManager.player_data.idleBattleData.characters
	if characters[0]:
		partSlot1.update_character(characters[0])
	if characters[1]:
		partSlot2.update_character(characters[1])
	if characters[2]:
		partSlot3.update_character(characters[2])
	if characters[3]:
		partSlot4.update_character(characters[3])
		

func _on_party_slot_clicked(event: InputEvent, slot : PartySlot):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			PartySlotSelected(slot)
			pass
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			characterRemoved(slot)
			
			
#Functions for party stats panel
func UpdatePartyStats():
	partyDpsLabel.text = "Party DPS : %2.2f" %GameManager.CalcPartyDps()
	partyHealingLabel.text = "Party HPS : %2.2f" %GameManager.CalcPartyHps()
	partyHealthLabel.text = "Party Health : %d" %GameManager.CalcPartyHealth()
			
	
