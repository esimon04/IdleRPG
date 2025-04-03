extends Resource
class_name PlayerData

@export var count : int
@export var idleBattleData : IdleBattleData
var playerInventory : PlayerInventory
@export var playerCharacters : Array[CharacterResource]

@export var UniqueItemId : int

const saveName = "ethan63"
const save_path = "user://" + saveName + ".res"
const inventorySavePath = "user://" + saveName + "Inv.res"

func updateData(countIn : int):
	count = countIn
	pass
	
func get_unique_id() -> int:
	UniqueItemId = UniqueItemId + 1
	return UniqueItemId


static func loadData() -> Resource:
	var data = ResourceLoader.load(save_path, "" , 1)
	data.playerInventory = ResourceLoader.load(inventorySavePath, "", 1)
	#data.playerInventory.load_unique_items()
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
	instance.UniqueItemId = 1000 #Starting at 1000

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
