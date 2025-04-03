extends Node

var player_data: PlayerData = null  # Stores the loaded player data
var loot_tables = {}
var itemDatabase = {}

func _ready():
	get_tree().auto_accept_quit = false
	itemDatabase = Item.LoadItemDatabase()
	load_player_data()
	load_loot_tables()
	
	
func _exit_tree() -> void:
	print("HELLO")
	get_tree().quit()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED || what == NOTIFICATION_CRASH || what == NOTIFICATION_EXIT_TREE || what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Game is quitting, saving data...")
		save_player_data()
		get_tree().quit()

func load_player_data():
	if PlayerData.saveExists():
		player_data = PlayerData.loadData()
		print("Loaded Player Data - GameManager")
		if player_data:
			if player_data.idleBattleData.enemyFighting:
				calculateIdleCombat()
			if not player_data.playerInventory:
				print("did not load inventory correctly")
		else:
			print("ERROR loading player data")
	else:
		print("Creating Player Data - GameManager")
		player_data = PlayerData.CreateSave()
		var dropped_items = []
		dropped_items.append({"item" : "Gold", "quantity": 4})
		dropped_items.append({"item" : "Sword1", "quantity": 1, "level" : 3})
		dropped_items.append({"item" : "Staff1", "quantity": 1, "level" : 3})
		PlayerLootedItems(dropped_items)

func save_player_data():
	if player_data:
		player_data.saveData()
		print("Player Data Saved")

func setEnemy(enemy : EnemyResource):
	if player_data:
		player_data.idleBattleData.enemyFighting = enemy
		
func pauseCombat():
	print("Pausing Combat")
	

	
func calculateIdleCombat():
	var currentTime = Time.get_unix_time_from_system();
	var timeDiff = (currentTime - player_data.idleBattleData.timeSaved)
	
	var dps = 0
	var healing = 0
	var partyHp = 0
	for char in player_data.idleBattleData.characters:
		if char:
			dps += char.calculateIdleDPS()
			healing += char.getHealingPerSecond()
			partyHp += char.getHealth()
		
	var enemyDps = player_data.idleBattleData.enemyFighting.damage / player_data.idleBattleData.enemyFighting.attackRate
	if enemyDps > healing:
		var healDiff = enemyDps - healing
		var time = partyHp / healDiff
		if time < timeDiff:
			print("party died")
			timeDiff = time
		
		
	var totalDmg = dps * timeDiff
	print("Idle Stats \n Total Damage %d \n Total Time %f \n party dps %f \n enemyDps %f \n partyHps %f \n enemy name %s"
			 %[totalDmg, timeDiff, dps, enemyDps, healing, player_data.idleBattleData.enemyFighting.name])
	var numEnemiesKilled = floor(totalDmg / player_data.idleBattleData.enemyFighting.health)
	print("KILLED %d ENEMEIS WHILE AWAY" %numEnemiesKilled)
	
	player_data.idleBattleData.enemyFighting.RollIdleLoot(numEnemiesKilled)
	pass
	
func CalcPartyDps() -> float:
	var dps = 0
	for char in player_data.idleBattleData.characters:
		if char:
			dps += char.calculateIdleDPS()
	return dps
	
func CalcPartyHps() -> float:
	var hps = 0
	for char in player_data.idleBattleData.characters:
		if char:
			hps += char.getHealingPerSecond()
	return hps
	
func CalcPartyHealth() -> float:
	var hp = 0
	for char in player_data.idleBattleData.characters:
		if char:
			hp += char.getHealth()
	return hp
	
func load_loot_tables():
	var file = FileAccess.open("res://EnemyResources/loot_tables.json", FileAccess.READ)
	if file:
		loot_tables = JSON.parse_string(file.get_as_text())
		
func get_enemy_loot(enemy_id: String) -> Array:
	return loot_tables.get(enemy_id, [])

func getItemFromDatabase(item_id: String) -> Item:
	var item = load(itemDatabase[item_id])
	if item.unique:
		return item.duplicate()
	else:
		return item
		
func PlayerLootedItemsIdle(itemsLooted : Array): #Making Idle variant so that only top X amt of items are looted
	
	for idx in itemsLooted:
		var item = GameManager.getItemFromDatabase(idx["item"])
		if item.unique:
			
			#Roll all the rarities
			var rarities = Equipment.GetTopDrops(idx["level"],idx["quantity"])
			
			for rarity in rarities:
				if item is Equipment:
					var newItem = item.duplicate()
					newItem.rarity = rarity
					newItem.numModifiers = Equipment.getNumModifiers(newItem.rarity)
					var newModifiers = (Equipment.rollStats(newItem.possibleModifiers,newItem.numModifiers, idx["level"]))
					newItem.modifiers.append_array(newModifiers)
					var unique_id = player_data.get_unique_id()
					newItem.id = newItem.name + "_" + str(unique_id)
					player_data.playerInventory.add_item(newItem, 1)
		else:
			item.id = item.name
			player_data.playerInventory.add_item(item, idx["quantity"])
	
func PlayerLootedItems(itemsLooted : Array): #items looted has "item" "quantity" "level"
	for idx in itemsLooted:
		var item = GameManager.getItemFromDatabase(idx["item"])
		if item.unique:
			for i in idx["quantity"]:
				if item is Equipment:
					item.rarity = Equipment.RollRarity(idx["level"])
					item.potential = Equipment.RollPotential()
					item.numModifiers = Equipment.getNumModifiers(item.rarity)
					var newModifiers = (Equipment.rollStats(item.possibleModifiers.duplicate(),item.numModifiers, idx["level"]))
					item.modifiers.append_array(newModifiers)
					var unique_id = player_data.get_unique_id()
					item.id = item.name + "_" + str(unique_id)
					player_data.playerInventory.add_item(item, 1)
		else:
			item.id = item.name
			player_data.playerInventory.add_item(item, idx["quantity"])

func PlayerReceivedItems(items : Array[String], ilvl):
	for itemName in items:
		var item = GameManager.getItemFromDatabase(itemName)
		if item.unique:
			if item is Equipment:
				item.rarity = Equipment.RollRarity(ilvl)
				item.numModifiers = Equipment.getNumModifiers(item.rarity)
				var newModifiers = (Equipment.rollStats(item.possibleModifiers,item.numModifiers, item.itemLevel))
				item.modifiers.append_array(newModifiers)
				var unique_id = player_data.get_unique_id()
				item.id = item.name + "_" + str(unique_id)
				player_data.playerInventory.add_item(item, 1)
		else:
			item.id = item.name
			player_data.playerInventory.add_item(item, 1)
		
func updateParty(_party):
	player_data.idleBattleData.characters = _party


func _on_enemy_enemy_died(enemy: Enemy) -> void:
	#update exp
	for char in GameManager.player_data.idleBattleData.characters:
		if char:
			char.getExperience(enemy.enemyType.expGiven)
	
	pass # Replace with function body.
