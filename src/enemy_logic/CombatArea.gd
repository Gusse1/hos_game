extends Node

@onready var enemies : Node = $Enemies

var curr_wave : int = 0
var cleared : bool = false

@export var waves : Array[Node3D]

func _ready():
	for wave in waves:
		wave.process_mode = 4 # process_mode = 4 is disabled
		wave.visible = false

func _process(delta):
	if curr_wave > 0 and not cleared:
		if waves[curr_wave-1].get_child_count() == 0: # All enemies dead (freed from scene)
			_progress_waves()


func _on_area_entered(area):
	#for enemy in enemies.get_children():
	#	print_debug(enemy)
	#	enemy.get_node("CharacterBody3D/EnemyResources")._activate()
	if area.name == "PlayerArea":
		_progress_waves()

func _progress_waves():
	if curr_wave < waves.size():
		waves[curr_wave].process_mode = 0 # process_mode = 0 is normal mode
		waves[curr_wave].visible = true
		curr_wave += 1
	else:
		print_debug("Combat area finished")
		cleared = true