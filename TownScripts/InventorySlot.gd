extends Control
class_name InventorySlot

@export var item: Item  # The item assigned to this slot
@export var quantity: int = 0  # The quantity of the item

@export var item_icon : TextureRect # Reference to UI elements
@export var item_button : Button
@export var item_quantity_label : Label

var tooltip: ItemTooltip = null  # Reference to tooltip instance

func _ready():
	update_slot()

func update_slot():
	if item:
		item_icon.texture = item.sprite  # Set the texture from the item resource
		item_quantity_label.text = str(quantity) if quantity > 1 else ""  # Show quantity if >1
		item_icon.visible = true
	else:
		item_icon.texture = null  # Hide icon if no item
		item_quantity_label.text = ""
		item_icon.visible = false

func set_item(new_item: Item, new_quantity: int):
	item = new_item
	quantity = new_quantity
	update_slot()


func _on_button_button_down() -> void:
	if item:
		#print("Clicked on item: %s (x%d)" % [item.name, quantity])
		pass
		# Handle item interaction (e.g., use, drop, inspect)
		
# Show tooltip when hovering over an item
func _on_mouse_entered():
	if item:
		tooltip = preload("res://Scenes/item_tooltip.tscn").instantiate()
		get_tree().root.add_child(tooltip)  # Add to the scene
		tooltip.update_item(item)
		tooltip.global_position = get_global_mouse_position() + Vector2(10, 10)  # Set initial position

# Hide tooltip when the mouse leaves
func _on_mouse_exited():
	if tooltip:
		tooltip.queue_free()
		tooltip = null
