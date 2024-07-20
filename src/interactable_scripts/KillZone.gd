extends Node

@export var playerState: PlayerState

func _on_area_entered(area: Area3D):
	if area.name == "PlayerArea":
		playerState._adjust_health(-999)

