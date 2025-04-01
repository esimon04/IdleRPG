extends Resource
class_name PlayerInventory

@export var slots: Dictionary  # Key: ItemID, Value: InventoryItem
@export var equipmentModifiers: Dictionary #Key ItemID, Value: EquipmentModifiers

signal InventoryChanged

# Function to add items, stacking if possible
func add_item(new_item: Item, amount: int = 1):
	var itemName = new_item.name
	var itemId = new_item.id
	
	
	if itemId in slots && !new_item.unique:
		# Stack onto existing slot, but cap at max_stack
		var space_left = new_item.max_stack - slots[itemId].count
		var to_add = min(amount, space_left)
		slots[itemId].count += to_add
		amount -= to_add
	else:
		# Create a new slot entry
		var invEntry = InventoryItem.new()
		invEntry.count = min(amount, new_item.max_stack)
		invEntry.item = new_item
		slots[itemId]= invEntry
		amount -= slots[itemId].count
	
	# If there’s leftover, recursively try again
	#Just going to put a max stack count.
	#if amount > 0:
	#	add_item(new_item, amount)
		
	InventoryChanged.emit()

# Function to remove items
func remove_item(item: Item, amount: int = 1) -> bool:
	var itemName = item.name
	var itemId = item.id
	if itemId in slots:
		if slots[itemId].count > amount:
			slots[itemId].count -= amount
			InventoryChanged.emit()
			return true
		else:
			slots.erase(itemId)  # Remove item from inventory if count reaches 0
			InventoryChanged.emit()
			return true
	return false  # Item was not in inventory

# Function to get quantity of an item
func get_quantity(item: Item) -> int:
	return slots[item.id].count
