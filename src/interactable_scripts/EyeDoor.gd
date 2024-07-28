extends CSGBox3D

@export var eyes : Array[Node3D]
var door_fog : Node3D
var active_eyes : int
var is_door_open : bool

func _ready():
	door_fog = get_parent().get_node("door_fog")
	
	door_fog.process_mode = 4
	door_fog.visible = false


func _process_eye(eye : Node3D):
	var all_eyes_active = true

	for i in eyes:
		if not i.is_eye_shot:
			all_eyes_active = false
			_close_door()
			break
	
	if all_eyes_active:
		_open_door()


func _open_door():
	door_fog.process_mode = 0
	door_fog.visible = true
	
	use_collision = false
	visible = false


func _close_door():
	door_fog.process_mode = 4
	door_fog.visible = false
	
	use_collision = true
	visible = true


# Signals
func _on_combat_area_1_wave_cleared():
	_open_door()


func _on_combat_area_2_wave_cleared():
	_open_door()


func _on_combat_area_3_wave_cleared():
	_open_door()
