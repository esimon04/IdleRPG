class_name Enemy
extends Node

#Enemy Stats
var health : int
var damage : int
var attackRate : float #In seconds
var currentHealth : int
var enemyName : String

var enemyIsHere : bool

@export var healthLabel : Label
@export var healthBar : ProgressBar
@export var nameLabel : Label
@export var playerParty : Party
@export var enemyType : EnemyResource
@export var attackTimer : Timer
@export var respawnProgress : ProgressBar
@export var enemyTexture : Sprite2D
@export var respawnTimer : Timer

@onready var spriteNode = $Character

var respawnTime = 1
var loot_table = {}

signal enemy_died(enemy: Enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadEnemy()
	respawnProgress.max_value = respawnTime
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	respawnProgress.value = 1 +  (respawnTimer.time_left - respawnTimer.wait_time)
	pass


	
func updateHealthLabel() -> void:
	healthLabel.text = "%d / %d" % [currentHealth, health]
	healthBar.value = currentHealth
	pass
	
func updateNameLabel() -> void:
	nameLabel.text = "%s" %enemyName
	pass
	
func setEnemy(enemy : EnemyResource):
	enemyType = enemy
	if enemyType == null:
		#Combat needs to pause here
		enemyIsHere = false
		health = 999
		name = "Nothing"
		healthBar.max_value = health
		updateHealthLabel()
		updateNameLabel()
	else:
		enemyIsHere = true
		print("Loading Enemy %s" %enemyType.name)
		loadEnemy()
	pass
	
func loadEnemy():
	if enemyIsHere:
		spriteNode.texture = enemyType.sprite
		health = enemyType.health
		attackRate = enemyType.attackRate
		damage=enemyType.damage
		currentHealth = health
		enemyName = enemyType.name
		healthBar.max_value = health
		updateHealthLabel()
		updateNameLabel()
		attackTimer.wait_time = attackRate
		attackTimer.start()
		loot_table = GameManager.get_enemy_loot(enemyType.enemyId)
	pass
	
func TakeDamage(amount: int):
	currentHealth -= amount
	if currentHealth <= 0:
		currentHealth = health
		Die()
	updateHealthLabel()
	pass
	
func Die():
	print("Enemy Died!")
	RollLoot()
	enemy_died.emit(self)  # Emit signal so other nodes can react
	respawnTimer.start(respawnTime)
	enemyTexture.texture = null
	enemyIsHere = false
	#queue_free()  # Remove the enemy from the scene
	pass
	
func Attack():
	if enemyIsHere:
		playerParty.TakeDamage(damage)
	pass


func _on_attackTimer_timeout() -> void:
	Attack()
	pass # Replace with function body.
	
func enemy_respawn() -> void:
	print("Enemy Respawned!")
	enemyIsHere = true
	enemyTexture.texture = enemyType.sprite
	attackTimer.start()
	pass
	
func RollLoot():
	enemyType.RollLoot()
			
	
