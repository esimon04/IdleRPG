class_name Party
extends Node

@export var Character1 : Character
@export var Character2 : Character
@export var Character3 : Character
@export var Character4 : Character
@export var healthLabel : ProgressBar
@export var enemy : Enemy

var totalHealth : int
var currentHealth : float
var healingPerSecond : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateParty()
	UpdateValues()
	currentHealth = totalHealth
	updateHealthLabel()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var healingAmt = delta * healingPerSecond
	currentHealth += healingAmt
	if currentHealth > totalHealth:
		currentHealth = totalHealth
		
	updateHealthValue()
	pass
	
func updateParty():
	setParty(GameManager.player_data.idleBattleData.characters)

func updateHealthLabel() -> void:
	healthLabel.min_value = 0
	healthLabel.max_value = totalHealth
	updateHealthValue()
	pass
	
func updateHealthValue() -> void:
	#healthLabel.text = "%3f / %d" % [currentHealth, totalHealth]
	healthLabel.value = currentHealth
	pass
	
func TakeDamage(amount: int):
	currentHealth -= amount
	updateHealthValue()
	pass
	
func DoDamage(amount: int):
	if enemy.enemyIsHere:
		enemy.TakeDamage(amount)
	pass
	
func UpdateValues():
	totalHealth = 0
	totalHealth += Character1.health
	totalHealth += Character2.health
	totalHealth += Character3.health
	totalHealth += Character4.health
	
	healingPerSecond = 0
	healingPerSecond += Character1.healing
	healingPerSecond += Character2.healing
	healingPerSecond += Character3.healing
	healingPerSecond += Character4.healing
	
	updateHealthLabel()
	
	pass
		
func setParty(characterResources : Array[CharacterResource]):
	Character1.setCharacter(characterResources[0])
	Character2.setCharacter(characterResources[1])
	Character3.setCharacter(characterResources[2])
	Character4.setCharacter(characterResources[3])
	
	UpdateValues()
	pass
	
