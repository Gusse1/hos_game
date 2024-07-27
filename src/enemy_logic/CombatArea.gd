extends Node

#@onready var enemies : Node = $Enemies

var curr_wave : int = 0
var cleared : bool = false
var active : bool = false
@export var num_of_waves : int

#@export var waves : Array[Node3D]

var waves : Array[Node3D]
var curr_copy_wave : Node3D

signal wave_cleared

func _ready():
	for child in get_children():
		if child.name.contains("Wave"):
			child.process_mode = 4 # process_mode = 4 is disabled
			child.visible = false
			waves.append(child)

func _process(delta):
	if curr_wave > 0 and not cleared:
		if curr_copy_wave.get_child_count() == 0 or curr_copy_wave == null: # All enemies dead (freed from scene)
			_progress_waves()

func _on_area_entered(area):
	if area.name == "PlayerArea" && not active:
		active = true
		_progress_waves()

func _reset_area():
	curr_wave = 0
	
	for child in get_children():
		if child.name.contains("_COPY"):
			child.queue_free()
	
	active = false
	cleared = false
	curr_wave = 0
	print_debug("Combat area reset")


func _progress_waves():
	if num_of_waves > curr_wave:
		print_debug(str(curr_wave) + " num of wave")
		curr_copy_wave = waves[curr_wave]._activate_wave()
		curr_wave += 1
	else:
		print_debug("Combat area finished")
		cleared = true
		wave_cleared.emit()
