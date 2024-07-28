extends Node

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Healing"):
		if shared_variables.player_state.current_blood > 0 and shared_variables.player_state.current_health < shared_variables.player_state.playerVariables.MAX_HEALTH:
			shared_variables.player_state._adjust_blood(-shared_variables.player_state.playerVariables.HEALING_SPEED * delta * 0.6)
			shared_variables.player_state._adjust_health(shared_variables.player_state.playerVariables.HEALING_SPEED * delta)

