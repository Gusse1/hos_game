extends Node3D

var is_eye_shot : bool
@export var eye_blind : Node3D

# Called when the eye is shot. Closes the eye and sends the info over to the door
func _shot_eye():
	print_debug("Eye shot")
	is_eye_shot = true
	eye_blind.visible = true
	get_parent().get_parent().get_node("door")._process_eye(self)
