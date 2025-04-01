extends Panel
class_name Town

@onready var monster_menu = $MonsterSelectionMenu  # Reference to the monster selection menu
@export var battle : BattleScreen
@export var tavern : Tavern

func _ready():
	monster_menu.hide()  # Ensure the menu is hidden at start
	tavern.hide()
	for button in get_tree().get_nodes_in_group("MonsterSelectButtons"):
		button.GotoCombat.connect(_on_enemy_selected)
	
func GotoCombat():
	hide()
	
func GotoTown():
	show()
	
	
#Area Specific

func _on_monster_selection_button_pressed():
	monster_menu.show()  # Show the menu when button is clicked

func _on_close_menu_button_pressed():
	monster_menu.hide()  # Hide the menu when close is clicked
	
	
# Signals 
func _on_enemy_selected(enemy: EnemyResource):
	print("Town received enemy selection: %s" % enemy.name)
	if battle.enemy_data != enemy:
		battle.set_enemy(enemy)
	GotoCombat()


func _on_goto_combat_button_down() -> void:
	GotoCombat()
	pass # Replace with function body.


func _on_enemy_enemy_died(enemy: Enemy) -> void:
	#Need this for things like updating whatever the player is looking at
	
	
	pass # Replace with function body.


func _on_open_tavern_button_down() -> void:
	tavern.show()
	tavern.OpenTavern()
	pass # Replace with function body.
