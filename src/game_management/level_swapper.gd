extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _swap_level(level_name: String):
	get_tree().change_scene_to_file("res://scenes/" + level_name + ".tscn")


func _on_cutscene_video_finished():
	_swap_level("level_2")


func _on_area_entered(area):
	if area.name == "PlayerArea":
		_swap_level("cutscene_hub_enter")
