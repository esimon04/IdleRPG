extends Resource
class_name IdleBattleData

@export var timeSaved : float
@export var enemyFighting : EnemyResource
@export var characters : Array[CharacterResource]

#Party Stats
func SetPartySlot(character : CharacterResource, index : int):
	characters[index] = character
