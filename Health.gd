extends Node
class_name Health

var health : int
var currentHealth : float
@export var healthLabel : Label
@export var healthBar : ProgressBar
var damageResistances : Dictionary #TODO

signal died

func TakeDamage(amount: int, type : DamageTypes.DamageType):
	
	var resistance = damageResistances.get(type, 0.0)
	var finalAmt = amount / (1 + (resistance / 100))
	
	currentHealth -= finalAmt
	if currentHealth <= 0:
		currentHealth = health
		died.emit()
	updateHealthLabel()
	pass
	
func Heal(amount: float):
	currentHealth += amount
	if currentHealth > health:
		currentHealth = health
	updateHealthLabel()
	
func updateHealthLabel() -> void:
	healthLabel.text = "%d / %d" % [currentHealth, health]
	healthBar.value = currentHealth
	pass
	
func SetHealth(amount:int):
	health = amount
	currentHealth = health
	healthBar.max_value = health
	healthBar.min_value = 0
	updateHealthLabel()
	
func SetResistances(res : Dictionary):
	damageResistances = res
