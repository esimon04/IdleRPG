class_name Character
extends Node

var health : int
var attackRate : float #In seconds
var healing : float #In seconds

@export var attackTimer : Timer
@export var party : Party
@export var nameLabel : Label
@export var attackProgBar : ProgressBar

@export var characterType : CharacterResource
@onready var spriteNode = $Character  # Adjust based on your node structure


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attackProgBar.value = attackTimer.wait_time +  (attackTimer.time_left - attackTimer.wait_time)
	pass


func _on_character_attack_timer_timeout() -> void:
	Attack()
	pass # Replace with function body.
	
func Attack():
	var damage = characterType.calculateDamage()
	party.DoDamage(damage)
	pass
	
func setCharacter(characterIn : CharacterResource):
	if characterIn:
		characterType = characterIn
		characterType.character_changed.connect(_on_character_changed)
		loadCharacter()
	else:
		removeCharacter()
		
	
func loadCharacter():
	updateCharacterValues()
	nameLabel.text = characterType.name
	spriteNode.texture = characterType.sprite
	pass
	
func updateCharacterValues():
	health = characterType.getHealth()
	attackRate = characterType.calculateAttackRate()
	healing = characterType.getHealingPerSecond()
	attackProgBar.max_value = attackRate
	attackTimer.wait_time = attackRate
	attackTimer.start()
	
func removeCharacter():
	health = 0
	attackRate = 0
	healing = 0
	nameLabel.text = ""
	attackTimer.stop()
	spriteNode.texture = null
	
func _on_character_changed():
	updateCharacterValues()
	party.updatePartyValues()
	
