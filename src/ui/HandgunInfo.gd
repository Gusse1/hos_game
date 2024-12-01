extends Node3D

@export var AmmoText : RichTextLabel

@export var  blood_bar : ProgressBar
@export var health_bar : ProgressBar
@export var gun_tip_position : Node3D

func _update_blood_display(current_blood : float, max_blood : float):
	blood_bar.value = (current_blood/max_blood) * 100

func _update_health_display(current_health : float, max_health : float):
	health_bar.value = (current_health/max_health) * 100
