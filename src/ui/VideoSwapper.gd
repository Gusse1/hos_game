extends Node

@export var videos : Array[VideoStreamTheora]
@export var videostream : VideoStreamPlayer

func swap_videos(target_video_int: int):
	videostream.stream = videos[target_video_int]
	videostream.play()
	print_debug("Video swapped")
