extends Node


@export_group("Vitality")
@export var MAX_HEALTH: float = 10

@export_group("Behaviour")
@export var FOLLOW_THRESHOLD: float = 10
@export var MOVEMENT_SPEED: float = 5
@export var ATTACK_RANGE: float = 2
@export var ATTACK_DAMAGE: float = 4

@export_group("Other")
@export var COST: int = 1

var current_health: float

func _ready():
	current_health = MAX_HEALTH

func _spawn_blood_cloud():
	pass

func _heal(amount: float):
	current_health += amount
	
	if current_health > MAX_HEALTH:
		current_health = MAX_HEALTH

func _damage(amount: float):
	current_health -= amount
	
	if current_health <= 0:
		current_health = 0
		print_debug("is kill")
		get_parent().get_parent().queue_free()
