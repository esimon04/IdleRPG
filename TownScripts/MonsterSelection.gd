extends Node

func _on_monster_selected(monster: EnemyResource):
	print("Player chose to fight:", monster.name)
	# Transition to battle scene with selected monster
