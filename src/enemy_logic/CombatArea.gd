extends Node

@onready var enemies : Node = $Enemies



func _on_area_entered(area):
	for enemy in enemies.get_children():
		print_debug(enemy)
		enemy.get_node("CharacterBody3D/EnemyResources")._activate()
