extends Control
class_name ItemDisplay
@export var item : Item
@export var texture : TextureRect

func _update_item(itemIn : Item):
	if itemIn:
		item = itemIn
		texture.texture = itemIn.sprite
	else:
		item = null
		texture.texture = null

func _on_use_item_button_down() -> void:
	if item is Consumable:
		item.OnUse()
	pass # Replace with function body.


func _on_delete_item_button_down() -> void:
	if item:
		GameManager.player_data.playerInventory.remove_item(item, 1)
		_update_item(null)
	pass # Replace with function body.
