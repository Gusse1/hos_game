extends Node

@export var level_to_swap_to : String

func _swap_level():
	print_debug("Swapping level to: " + level_to_swap_to)
	get_tree().change_scene_to_file("res://scenes/" + level_to_swap_to + ".tscn")


func _on_cutscene_video_finished():
	_swap_level()


func _on_area_entered(area):
	if area.name == "PlayerArea":
		_swap_level()


func _on_level_end_area_entered(area):
	_swap_level()
