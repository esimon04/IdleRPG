extends Control
class_name PartySlot

@export var character : CharacterResource
@export var characterSprite : TextureRect
@export var characterName : Label
@export var characterLevel : Label
@export var button : Button

var partyManager : PartyManager

func update_character(new_character: CharacterResource):
	if not new_character:
		print("ERROR: No character provided to PartySlot!")
		return

	character = new_character
	characterSprite.texture = character.sprite if character.sprite else null
	characterName.text = character.name
	characterLevel.text = "Level: %d" % character.level
	
func removeCharacter():
	if character:
		character = null
		characterSprite.texture = null
		characterName.text = ""
		characterLevel.text = ""
	
func hasCharacter() -> bool:
	return character != null


func _on_remove_from_party_button_down() -> void:
	
	if partyManager && hasCharacter():
		partyManager.characterRemoved(character)
		removeCharacter()
		
	pass # Replace with function body.
