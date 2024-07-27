extends Node3D



# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = 4
	visible = false

func _enable():
	process_mode = 0
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += Vector3(0,delta*1,0)

func _collect_artifact():
	get_node("LevelSwapper")._swap_level()

func _on_artifact_zone_area_entered(area):
	if area.name == "PlayerArea":
		_collect_artifact()

func _on_combat_area_2_wave_cleared():
	_enable()


func _on_text_area_creator_area_entered(area):
	_enable()
