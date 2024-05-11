extends CharacterBody3D

@onready var player_node = get_tree().current_scene.get_node("Pawn").get_node("Body")
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_state: Node = $EnemyResources
@onready var attack_float : float = 0
@export var attack_float_cumulation : float = 1.25

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target()


func set_movement_target():
	navigation_agent.set_target_position(player_node.global_position)

func _physics_process(delta):
	
	#if player_node.global_position.distance_to(navigation_agent.get_parent().global_position) < enemy_state.FOLLOW_THRESHOLD:
	if enemy_state.ACTIVE:
		navigation_agent.set_target_position(player_node.global_position)

		var current_agent_position: Vector3 = global_position
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		
		
		velocity = current_agent_position.direction_to(next_path_position) * enemy_state.MOVEMENT_SPEED
		
		
		move_and_slide()
		
		# Attack player if in attack range
		if player_node.global_position.distance_to(navigation_agent.get_parent().global_position) < enemy_state.ATTACK_RANGE:
			_damage_player(delta)
		else:
			attack_float = 0
		
func _damage_player(delta):
	attack_float += attack_float_cumulation*delta
	if attack_float > 1:
		player_node.get_parent().get_node("PlayerState")._adjust_health(-enemy_state.ATTACK_DAMAGE)
		attack_float = 0
