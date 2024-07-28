extends Node

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

@export var healing_audio_stream: AudioStreamPlayer3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("Healing"):
		if shared_variables.player_state.current_blood > 0 and shared_variables.player_state.current_health < shared_variables.player_state.playerVariables.MAX_HEALTH:
			if not healing_audio_stream.playing:
				healing_audio_stream.play()
			shared_variables.player_state._adjust_blood(-shared_variables.player_state.playerVariables.HEALING_SPEED * delta * 0.6)
			shared_variables.player_state._adjust_health(shared_variables.player_state.playerVariables.HEALING_SPEED * delta)
	if Input.is_action_just_released("Healing"):
		healing_audio_stream.stop()

