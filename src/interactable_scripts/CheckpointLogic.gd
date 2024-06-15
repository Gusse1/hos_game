extends Area3D

@export var player : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _process_checkpoint():
	var player_state: PlayerState = player.get_node("PlayerState")
	
	# Fill health and blood. Safety checks are in the player_state script
	player_state._adjust_blood(999)
	player_state._adjust_health(999)
	
	player_state.current_checkpoint_location = global_position
	

func _on_area_entered(area):
	_process_checkpoint()
