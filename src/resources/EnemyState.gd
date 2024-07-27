extends Node


@export_group("Vitality")
@export var MAX_HEALTH: float = 10

@export_group("Behaviour")
@export var ACTIVE: bool = true
@export var FOLLOW_THRESHOLD: float = 10
@export var MOVEMENT_SPEED: float = 5
@export var ATTACK_RANGE: float = 2
@export var ATTACK_DAMAGE: float = 4
@export var IS_RANGED_ENEMY: bool = false

@export_group("Other")
@export var COST: int = 1

var current_health: float

@export var enemy_mesh: MeshInstance3D
@export var weak_material: StandardMaterial3D

func _ready():
	current_health = MAX_HEALTH


func _activate():
	ACTIVE = true


func _spawn_blood_cloud():
	if not IS_RANGED_ENEMY:
		var blood_cloud: PackedScene =  preload("res://assets/enemies/blood_cloud.tscn")
		var inst_blood_cloud: Node3D = blood_cloud.instantiate()
		inst_blood_cloud.position = get_parent().global_position + Vector3(0, 1, 0)
		get_tree().get_root().add_child(inst_blood_cloud)


func _heal(amount: float):
	current_health += amount
	
	if current_health > MAX_HEALTH:
		current_health = MAX_HEALTH


func _damage(amount: float):
	if current_health == MAX_HEALTH:
		MOVEMENT_SPEED *= 0.66
		enemy_mesh.set_surface_override_material(0, weak_material)
		
	current_health -= amount
	
	if current_health <= 0:
		current_health = 0
		print_debug("is kill")
		
		_spawn_blood_cloud()
		get_parent().get_parent().queue_free()
