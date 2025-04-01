extends Consumable
class_name Chest

@export var itemsToDrop : Array[String]
@export var chestLevel : int

func RollItemDrop() -> String:
	print("Rolling")
	var rng = RandomNumberGenerator.new()
	var idx = rng.randi_range(0, itemsToDrop.size() - 1)
	return itemsToDrop[idx]
	
func OnUse():
	GameManager.PlayerReceivedItems([RollItemDrop()], chestLevel)
	GameManager.player_data.playerInventory.remove_item(self,1)
