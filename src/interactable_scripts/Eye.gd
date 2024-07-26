extends Node3D

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

var is_eye_shot : bool
@export var is_timed_eye : bool
@export var timed_eye_time : float
var timed_eye_timer: float

var eye_blind: MeshInstance3D
var eye_holder: MeshInstance3D
var eye_light: OmniLight3D

func _ready():
	eye_blind = get_parent().get_node("EyeBlind")
	eye_holder = get_parent().get_node("EyeHolder")
	eye_light = get_parent().get_node("OmniLight3D")
	
	if is_timed_eye:
		eye_light.light_color = Color(0.3, 0.7, 0, 1)

func _process(delta: float):
	if is_timed_eye:
		if timed_eye_timer < 0 && is_eye_shot:
			_disable_eye()
		else:
			timed_eye_timer -= delta
		

# Called when the eye is shot. Closes the eye and sends the info over to the door
func _shot_eye():
	print_debug("Eye shot")
	is_eye_shot = true
	eye_blind.visible = true
	get_parent().get_parent().get_node("door")._process_eye(self)
	if is_timed_eye:
		timed_eye_timer = timed_eye_time


func _disable_eye():
	print_debug("Eye disabled")
	is_eye_shot = false
	eye_blind.visible = false
	get_parent().get_parent().get_node("door").process_mode = 0
	get_parent().get_parent().get_node("door")._process_eye(self)
