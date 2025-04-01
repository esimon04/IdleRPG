extends Resource
class_name EnemyResource

@export var name: String
@export var sprite: Texture
@export var health: int
@export var damage: int
@export var attackRate : float
@export var enemyId : String
@export var expGiven : float
@export var level : int
@export var damageType : DamageTypes.DamageType

func RollLoot():
	var dropped_items = []
	var loot_table = GameManager.get_enemy_loot(enemyId)
	if loot_table:
		for drop in loot_table:
			var dropChance = drop["drop_chance"]
			var roll = randf() * 100
			if roll <= dropChance:
				var item = drop["item"]
				var minDrop = drop["min"]
				var maxDrop = drop["max"]
				if item:
					var quant = randi_range(minDrop, maxDrop)
					dropped_items.append({"item" : item, "quantity": quant, "level" : level})
					
	if dropped_items:
		#print("Dropped Items %s" %dropped_items)
		GameManager.PlayerLootedItems(dropped_items)
		
		
func RollIdleLoot(numKilled : int):
	var dropped_items = []
	var loot_table = GameManager.get_enemy_loot(enemyId)
	if loot_table:
		for drop in loot_table:
			
			var dropChance = drop["drop_chance"] / 100
			var minDrop = drop["min"]
			var maxDrop = drop["max"]
			var expectedNum = dropChance * numKilled * ((minDrop + maxDrop) / 2)
			var variance = expectedNum * .2
			var finalAmount = int(round(expectedNum + randf_range(-variance, variance)))
			finalAmount = max(finalAmount, 0)
			
			var item = drop["item"]
			if finalAmount > 0:
					
				dropped_items.append({"item" : item, "quantity": finalAmount, "level" : level})
					
	if dropped_items:
		#print("Dropped Items %s" %dropped_items)
		GameManager.PlayerLootedItemsIdle(dropped_items)
