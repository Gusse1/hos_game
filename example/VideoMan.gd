extends Node

@export var videoswapper : Node
@export var original_video_int : int
@export var target_swap_video_int : int
var is_video_swapped : bool


func _on_area_3d_area_entered(area):
	print_debug(area.name)
	if area.name == "PlayerArea":
		var swap_video_int = 0
		if is_video_swapped:
			swap_video_int = original_video_int
			is_video_swapped = false
		elif not is_video_swapped:
			swap_video_int = target_swap_video_int
			is_video_swapped = true
		videoswapper.swap_videos(swap_video_int)

