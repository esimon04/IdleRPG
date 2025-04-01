extends Control
class_name EquipmentSlot

var equipment : Equipment
@export var equipmentType : Equipment.EquipmentType
@export var icon : TextureRect
@export var button : Button
var tooltip: ItemTooltip = null  # Reference to tooltip instance

func _ready():
	update_slot()

func update_slot():
	if equipment:
		icon.texture = equipment.sprite  # Set the texture from the item resource
		icon.visible = true
	else:
		icon.texture = null  # Hide icon if no item
		icon.visible = false

func set_item(new_item: Equipment):
	equipment = new_item
	update_slot()
	
func _on_mouse_entered():
	if equipment:
		tooltip = preload("res://Scenes/item_tooltip.tscn").instantiate()
		get_tree().root.add_child(tooltip)  # Add to the scene
		tooltip.update_item(equipment)
		tooltip.global_position = get_global_mouse_position() + Vector2(10, 10)  # Set initial position

# Hide tooltip when the mouse leaves
func _on_mouse_exited():
	if tooltip:
		tooltip.queue_free()
		tooltip = null
