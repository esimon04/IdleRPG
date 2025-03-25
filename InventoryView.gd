extends Node
class_name InventoryView

@export var inventory_grid_container : GridContainer

signal itemSelected(slot)

func _ready():
	GameManager.player_data.playerInventory.InventoryChanged.connect(_on_inventory_changed)

func update_inventory_display():
	var player_inventory = GameManager.player_data.playerInventory
	for child in inventory_grid_container.get_children():
		child.queue_free()
	#inventory_grid_container.clear()  # Remove previous items
	 # Populate grid with current inventory
	for itemId in player_inventory.slots.keys():
		var invItem = player_inventory.slots[itemId]
		var slot_ui = preload("res://Scenes/inventory_slot.tscn").instantiate()
		slot_ui.set_item(invItem.item, invItem.count)
		slot_ui.item_button.pressed.connect(_on_item_selected.bind(slot_ui))
		inventory_grid_container.add_child(slot_ui)


func _on_enemy_enemy_died(enemy: Enemy) -> void:
	update_inventory_display()
	pass # Replace with function body.
	
func _on_item_selected(slot : InventorySlot):
	print("Selected Item %s" %slot.item.name)
	itemSelected.emit(slot)
	pass
	
func _on_inventory_changed():
	update_inventory_display()
