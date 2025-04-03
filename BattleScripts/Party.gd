class_name Party
extends Node

@export var Character1 : Character
@export var Character2 : Character
@export var Character3 : Character
@export var Character4 : Character
@export var enemy : Enemy
@export var health : Health
@export var totalHealth : int

var healingPerSecond : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateParty()
	UpdateValues()
	health.SetHealth(totalHealth)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var healingAmt = delta * healingPerSecond
	health.Heal(healingAmt)
	pass
	
func updateParty():
	setParty(GameManager.player_data.idleBattleData.characters)
	
func DoDamage(amount: int, type : DamageTypes.DamageType):
	if enemy.enemyIsHere:
		enemy.TakeDamage(amount, type)
	pass

func TakeDamage(amount:int, type : DamageTypes.DamageType):
	health.TakeDamage(amount, type)
	
func UpdateValues():
	totalHealth = 0
	totalHealth += Character1.health
	totalHealth += Character2.health
	totalHealth += Character3.health
	totalHealth += Character4.health
	health.SetHealth(totalHealth)
	
	healingPerSecond = 0
	healingPerSecond += Character1.healing
	healingPerSecond += Character2.healing
	healingPerSecond += Character3.healing
	healingPerSecond += Character4.healing
	
	pass
	
func updatePartyValues():
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
		
func setParty(characterResources : Array[CharacterResource]):
	Character1.setCharacter(characterResources[0])
	Character2.setCharacter(characterResources[1])
	Character3.setCharacter(characterResources[2])
	Character4.setCharacter(characterResources[3])
	
	UpdateValues()
	pass
	


func _on_tavern_party_changed() -> void:
	updateParty()
	pass # Replace with function body.


func _on_health_panel_died() -> void:
	#TODO
	print("party fucking died")
	pass # Replace with function body.
