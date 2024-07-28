extends Node

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

const save_file_location = "user://save_game.dat"
const level_save_location = "user://level_save.dat"

# Avoid race condition of sliders thinking their values change on ready. WHY GODOT?
var initial_load_complete: bool = false

var settings = {
	"pixelation_factor": 3,
	"volume": 50,
	"mouse_sensitivity": 12
	}

var loaded_level: String
@export var level_to_save: String

@export var level_saving_enabled: bool = true

func _ready():
	print_debug("TREE : " + str(get_tree()))
	load_settings()
	
	if level_saving_enabled:
		save_level()
	load_level()

func _apply_settings():
	if shared_variables.player_node:
		shared_variables.player_node.get_node("SVC").stretch_shrink = settings.pixelation_factor
		preload("res://addons/GoldGdt/Default.tres").MOUSE_SENSITIVITY = settings.mouse_sensitivity
	var db = -pow(100 - settings.volume, 2)
	AudioServer.set_bus_volume_db(0, linear_to_db(settings.volume/25))
	if initial_load_complete:
		shared_variables.settings_panel._update_settings_values()
	save_settings()
	initial_load_complete = true


func save_settings():
	save(settings)
	call_deferred("shared_variables.settings_panel._update_settings_values()")

func save(content):
	var file = FileAccess.open(save_file_location, FileAccess.WRITE)
	file.store_var(content)

func load_settings():
	print_debug("Loading settings")
	var file = FileAccess.open(save_file_location, FileAccess.READ)
	var content = file.get_var()
	settings = content
	_apply_settings()
	return settings
	
func save_level():
	var file = FileAccess.open(level_save_location, FileAccess.WRITE)
	file.store_var(level_to_save)

func load_level():
	var file = FileAccess.open(level_save_location, FileAccess.READ)
	var content = file.get_var()
	print("Loaded level from file: " + str(content))
	loaded_level = str(content)


func _on_pixelation_slider_value_changed(value):
	settings.pixelation_factor = value
	#save_settings()
	#print("settings saved to file as " + str(load_settings()))
	if initial_load_complete:
		_apply_settings()


func _on_volume_slider_value_changed(value):
	settings.volume = value
	#save_settings()
	#print("settings saved to file as " + str(load_settings()))
	if initial_load_complete:
		_apply_settings()

func _on_mouse_sens_slider_value_changed(value):
	settings.mouse_sensitivity = value
	#save_settings()
	#print("settings saved to file as " + str(load_settings()))
	if initial_load_complete:
		_apply_settings()
