extends Node

@export var enemy_holder: Enemy
@export var new_enemy_resource: EnemyResource  # Assign this in the Inspector

func _on_button_pressed():
	
	if enemy_holder:
		print("spawning enemy %s" %new_enemy_resource.name)
		enemy_holder.setEnemy(new_enemy_resource)


func _on_button_down() -> void:
	_on_button_pressed()
	pass # Replace with function body.
