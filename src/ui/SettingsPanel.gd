extends Panel

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

# Pixelation
@onready var pixelation_slider = $PixelationSlider
@onready var pixelation_number = $PixelationNumber

# Volume
@onready var volume_slider = $VolumeSlider
@onready var volume_number = $VolumeNumber

# Mouse Sensitivity
@onready var mouse_sens_slider = $MouseSensSlider
@onready var mouse_sens_number = $MouseSensNumber

var settings_update_delay: float = 2
var updated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_settings_values()

func _process(delta):
	if not updated:
		if settings_update_delay > 2:
			settings_update_delay -= delta
		else:
			_update_settings_values()
			updated = true
		
func _update_settings_values():
	print_debug("Updating settings values")
	pixelation_slider.value = shared_variables.save_game_manager.settings.pixelation_factor
	pixelation_number.text = str(shared_variables.save_game_manager.settings.pixelation_factor)

	volume_slider.value = shared_variables.save_game_manager.settings.volume
	volume_number.text = str(shared_variables.save_game_manager.settings.volume)
	
	mouse_sens_slider.value = shared_variables.save_game_manager.settings.mouse_sensitivity
	mouse_sens_number.text = str(shared_variables.save_game_manager.settings.mouse_sensitivity)
	
