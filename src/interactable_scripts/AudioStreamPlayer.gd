extends AudioStreamPlayer

func _play_audio():
	play()

func _on_text_area_creator_area_entered(area):
	play()
