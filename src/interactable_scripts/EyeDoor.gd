extends CSGBox3D

@export var eyes : Array[Node3D]
var active_eyes : int
var is_door_open : bool


func _process_eye(eye : Node3D):
	var all_eyes_active = true

	for i in eyes:
		if not i.is_eye_shot:
			all_eyes_active = false
			break
	
	if all_eyes_active:
		_open_door()


func _open_door():
	position = Vector3(position.x, position.y + 5, position.z)
	print_debug("Door opened")
