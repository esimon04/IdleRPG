extends Resource
class_name PlayerInventory

@export var slots: Dictionary  # Key: InventoryItem, Value: Quantity

signal InventoryChanged

# Function to add items, stacking if possible
func add_item(itemName: String, amount: int = 1):
	var new_item = GameManager.getItemFromDatabase(itemName)
	if itemName in slots:
		# Stack onto existing slot, but cap at max_stack
		var space_left = new_item.max_stack - slots[itemName]
		var to_add = min(amount, space_left)
		slots[itemName] += to_add
		amount -= to_add
	else:
		# Create a new slot entry
		slots[itemName] = min(amount, new_item.max_stack)
		amount -= slots[itemName]
	
	# If there’s leftover, recursively try again
	if amount > 0:
		add_item(new_item, amount)
		
	InventoryChanged.emit()

# Function to remove items
func remove_item(item: Item, amount: int = 1) -> bool:
	var itemName = item.name
	if itemName in slots:
		if slots[itemName] > amount:
			slots[itemName] -= amount
			InventoryChanged.emit()
			return true
		else:
			slots.erase(itemName)  # Remove item from inventory if count reaches 0
			InventoryChanged.emit()
			return true
	return false  # Item was not in inventory

# Function to get quantity of an item
func get_quantity(item: Item) -> int:
	return slots.get(item.name, 0)
