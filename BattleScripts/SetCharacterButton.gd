extends Node


@export var character: Character
@export var charResource: CharacterResource  # Assign this in the Inspector

func _on_button_pressed():
	
	if character:
		print("spawning enemy %s" %charResource.name)
		character.setCharacter(charResource)


func _on_button_down() -> void:
	_on_button_pressed()
	pass # Replace with function body.
