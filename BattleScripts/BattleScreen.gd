extends Node
class_name BattleScreen

var enemy_data: EnemyResource  # Store enemy info

@export var town : Town

func _ready():
	if GameManager.player_data.idleBattleData.enemyFighting:
		set_enemy(GameManager.player_data.idleBattleData.enemyFighting)

func set_enemy(enemy: EnemyResource):
	enemy_data = enemy
	update_enemy_display()

func update_enemy_display():
	if enemy_data:
		$Enemy.setEnemy(enemy_data)  # Update the battle enemy


func _on_goto_townbutton_button_down() -> void:
	town.GotoTown()
	pass # Replace with function body.
