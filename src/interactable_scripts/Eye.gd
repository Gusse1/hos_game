extends Node3D

var is_eye_shot : bool

# Called when the eye is shot. Closes the eye and sends the info over to the door
func _shot_eye():
	print_debug("Eye shot")
	is_eye_shot = true
	get_parent().get_parent()._process_eye(self)
