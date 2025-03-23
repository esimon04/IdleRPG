extends Button

@export var enemy : EnemyResource
signal GotoCombat(enemy: EnemyResource)  # Signal to notify Town

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = enemy.sprite
	text = enemy.name
	pass # Replace with function body.

func _on_button_down() -> void:
	print("Player Chose to fight : %s" %enemy.name)
	GameManager.setEnemy(enemy) # Store the enemy globally
	emit_signal("GotoCombat", enemy)
	pass # Replace with function body.
	
	
