extends Control
@export var character: CharacterResource
@export var character_sprite : TextureRect
@export var character_name : Label
@export var character_level : Label
@export var character_button : Button

#func _ready():
	# Connect button signal for selection
	#character_button.pressed.connect(_on_character_slot_pressed)

func update_character(new_character: CharacterResource):
	character = new_character
	character.character_changed.connect(_on_char_change)
	character_sprite.texture = character.sprite
	character_name.text = character.name
	character_level.text = "Level: %d" % character.level

func _on_character_slot_pressed():
	print("Selected character:", character.name)
	
func _on_char_change():
	character_sprite.texture = character.sprite
	character_name.text = character.name
	character_level.text = "Level: %d" % character.level
