class_name PlayerState extends Node

@export var playerVariables : PlayerVariables
var current_blood : float

# UI
@export var blood_text : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	current_blood = playerVariables.MAX_BLOOD



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _adjust_blood(amount: float):
	current_blood += amount
	blood_text.text = str(current_blood).pad_decimals(1)
	
	if current_blood < 0:
		current_blood = 0
	if current_blood > playerVariables.MAX_BLOOD:
		current_blood = playerVariables.MAX_BLOOD
