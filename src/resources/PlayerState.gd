class_name PlayerState extends Node

@export var playerVariables : PlayerVariables
var blood_accumulation_float : float # Player gets blood in bursts according to this value
var current_blood : float
var current_health : float
@export var blood_recovery_rate: float
@export var difficulty: int = 20
@export var player_body: Node3D

var current_checkpoint_location : Vector3

# UI
@export var blood_text : RichTextLabel
@export var handgun : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	current_blood = playerVariables.MAX_BLOOD
	current_health = playerVariables.MAX_HEALTH / 2
	handgun._update_health_display(current_health, playerVariables.MAX_HEALTH)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_passive_blood_accumulation(delta * blood_recovery_rate)
	pass
	
func _passive_blood_accumulation(amount: float):
	blood_accumulation_float += amount
	if blood_accumulation_float > 1.5:
		current_blood += blood_accumulation_float
		blood_accumulation_float = 0
		
	_adjust_blood(0)
	
func _adjust_blood(amount: float):
	current_blood += amount
	handgun._update_blood_display(current_blood, playerVariables.MAX_BLOOD)
	
	if current_blood < 0:
		current_blood = 0
	if current_blood > playerVariables.MAX_BLOOD:
		current_blood = playerVariables.MAX_BLOOD
		
func _adjust_health(amount: float):
	current_health += amount
	handgun._update_health_display(current_health, playerVariables.MAX_HEALTH)
	
	if current_health < 0:
		print_debug("dead")
		_kill_player()
		
	if current_health > playerVariables.MAX_HEALTH:
		current_health = playerVariables.MAX_HEALTH

func _kill_player():
	player_body.global_position = current_checkpoint_location
	_adjust_health(999)
	_adjust_blood(999)

	
func _on_player_area_area_entered(area):
	print_debug("Area entered player ", area.name)
	if area.name == "blood_cloud_trigger":
		_adjust_blood(playerVariables.PICKUP_BLOOD_GAIN)
		area.get_parent().queue_free()

