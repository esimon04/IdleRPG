extends Resource
class_name PlayerData

@export var count : int
@export var idleBattleData : IdleBattleData
var playerInventory : PlayerInventory
@export var playerCharacters : Array[CharacterResource]

const saveName = "ethan28"
const save_path = "user://" + saveName + ".res"
const inventorySavePath = "user://" + saveName + "Inv.res"

func updateData(countIn : int):
	count = countIn
	pass


static func loadData() -> Resource:
	var data = ResourceLoader.load(save_path, "" , 1)
	data.playerInventory = ResourceLoader.load(inventorySavePath, "", 1)
	print("loaded data")
	return data


func saveData():
	print("saving data")
	idleBattleData.timeSaved = Time.get_unix_time_from_system()
	ResourceSaver.save(self, save_path)
	ResourceSaver.save(playerInventory, inventorySavePath)
	
static func saveExists() -> bool:
	return FileAccess.file_exists(save_path)
	
static func CreateSave() -> PlayerData:
	var instance = PlayerData.new()
	instance.playerInventory = PlayerInventory.new()
	instance.playerInventory.add_item("Gold", 1)
	instance.playerInventory.add_item("Sword1",1)
	instance.idleBattleData = IdleBattleData.new()
	instance.idleBattleData.characters.append(null)
	instance.idleBattleData.characters.append(null)
	instance.idleBattleData.characters.append(null)
	instance.idleBattleData.characters.append(null)
	var wizard = load("res://CharacterResources/Wizard.tres").duplicate()
	var warrior = load("res://CharacterResources/Warrior.tres").duplicate()
	
	instance.playerCharacters.append(warrior)
	instance.playerCharacters.append(wizard)
	return instance
	print("Creating New Save - PlayerData")
