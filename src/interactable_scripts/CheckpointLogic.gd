extends Area3D

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

func _process_checkpoint():
	var player_state: PlayerState = shared_variables.player_state
	
	# Fill health and blood. Safety checks are in the player_state script
	player_state._adjust_blood(999)
	player_state._adjust_health(999)
	
	player_state.current_checkpoint_location = global_position
	
func _on_area_entered(area):
	_process_checkpoint()
