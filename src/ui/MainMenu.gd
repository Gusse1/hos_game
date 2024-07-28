extends Node

@export var menu_items: ItemList
@export var menu_panel : Panel
@export var intro_video_player : VideoStreamPlayer
@export var intro_background_video_player : VideoStreamPlayer
@export var settings_panel: Panel
@export var credits_panel: Panel
@export var save_game_manager: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _start_new_game():
	intro_background_video_player.stop()
	intro_video_player.play()
	menu_panel.hide()
	settings_panel.hide()
	credits_panel.hide()

func _open_credits_menu():
	if credits_panel.visible:
		credits_panel.visible = false
	else:
		credits_panel.visible = true

func _open_settings_menu():
	if settings_panel.visible:
		settings_panel.visible = false
	else:
		settings_panel.visible = true

func _close_game():
	get_tree().quit()

func _load_first_level():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _continue_game():
	print("res://scenes/" + save_game_manager.loaded_level + ".tscn")
	get_tree().change_scene_to_file("res://scenes/" + save_game_manager.loaded_level + ".tscn")

func _on_menu_items_item_clicked(index, at_position, mouse_button_index):
	menu_items.deselect_all()
	print_debug(index)
	if index == 0:
		_continue_game()
	if index == 1:
		_start_new_game()
	if index == 2:
		_open_settings_menu()
	if index == 3:
		_close_game()
	if index == 4:
		_open_credits_menu()


func _on_intro_video_finished():
	_load_first_level()
