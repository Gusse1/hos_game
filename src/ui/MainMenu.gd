extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_new_game():
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_menu_items_item_clicked(index, at_position, mouse_button_index):
	print_debug(index)
	if index == 1:
		_start_new_game()
