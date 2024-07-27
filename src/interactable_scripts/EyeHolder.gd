extends MeshInstance3D

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

# This script is a workaround to a Godot bug where it loses the path of the viewport on project reloads randomly
func _ready():
	get_active_material(1).set_texture(StandardMaterial3D.TEXTURE_ALBEDO, shared_variables.eye_screen_player.get_texture())
	get_active_material(1).set_texture(StandardMaterial3D.TEXTURE_EMISSION, shared_variables.eye_screen_player.get_texture())
