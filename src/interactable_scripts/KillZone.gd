extends Node

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

func _on_area_entered(area: Area3D):
	if area.name == "PlayerArea":
		shared_variables.player_state._adjust_health(-999)

