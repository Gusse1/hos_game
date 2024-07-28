extends "res://src/ui/MainMenu.gd"

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_released("pause_menu"):
		print_debug("Pause pressed")
		_pause()


func _pause():
	if get_parent().visible:
		get_parent().visible = false
		get_tree().paused = false
		shared_variables.post_process_layer._enable()
		_lock_mouse()
	else:
		get_parent().visible = true
		get_tree().paused = true
		shared_variables.post_process_layer._disable()
		_release_mouse()

func _release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _lock_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _exit_pause_menu():
	get_parent().visible = false

func _back_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_menu_items_item_clicked(index, at_position, mouse_button_index):
	menu_items.deselect_all()
	print_debug(index)
	if index == 0:
		_pause()
		_exit_pause_menu()
	if index == 1:
		_open_settings_menu()
	if index == 2:
		_back_to_main_menu()
	if index == 3:
		_open_credits_menu()
