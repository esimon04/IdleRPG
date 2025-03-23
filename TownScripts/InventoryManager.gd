extends Node

@export var invPanel : Control
@export var inventoryView : InventoryView

func _ready() -> void:
	invPanel.hide()

func _on_open_inventory_button_down() -> void:
	print("Opening Inventory")
	update_inventory_display()
	invPanel.show()
	pass # Replace with function body.


func _on_button_button_down() -> void:
	print("Close inv")
	invPanel.hide()
	pass # Replace with function body.

func update_inventory_display():
	inventoryView.update_inventory_display()
