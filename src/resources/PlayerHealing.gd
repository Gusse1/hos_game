extends Node


@export var playerState : PlayerState


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Healing"):
		if playerState.current_blood > 0 and playerState.current_health < playerState.playerVariables.MAX_HEALTH:
			playerState._adjust_blood(-playerState.playerVariables.HEALING_SPEED * delta)
			playerState._adjust_health(playerState.playerVariables.HEALING_SPEED * delta)
			print_debug("Healing")
		else:
			print_debug("Cannot heal stupid")
			

