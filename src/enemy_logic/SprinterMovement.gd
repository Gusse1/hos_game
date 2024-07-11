extends CharacterBody3D

@onready var player_node = get_tree().current_scene.get_node("Pawn").get_node("SVC").get_node("VC").get_node("Body")
@onready var player_state = get_tree().current_scene.get_node("Pawn").get_node("PlayerState")
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_model: Node3D = $enemy
@onready var enemy_state: Node = $EnemyResources
@onready var attack_float : float = 0
@export var attack_float_cumulation : float = 1.25

var enemy_spawner = preload("res://assets/enemies/enemy_spawner.tscn")
var start = true

var timer_set = false
var time: float
var start_time: float
var inst_enemy_spawner

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

func _enable_enemy():
	start = true

func _physics_process(delta):
	time+=delta
	if start:
		if not timer_set:
			start_time = time
			timer_set = true
			
		enemy_state.ACTIVE = false
		print_debug("ENEMY START")
		if not is_instance_valid(inst_enemy_spawner):
			inst_enemy_spawner = enemy_spawner.instantiate()
			inst_enemy_spawner.position = position
			add_child(inst_enemy_spawner)
		enemy_model.visible = false

		if time - start_time >= 2 and timer_set:
			enemy_model.visible = true
			inst_enemy_spawner.queue_free()
			start = false
			enemy_state.ACTIVE = true
		
	if enemy_state.ACTIVE and not start:
		navigation_agent.set_target_position(player_node.global_position)

		var current_agent_position: Vector3 = global_position
		var next_path_position: Vector3 = navigation_agent.get_next_path_position()
		enemy_model.rotation += Vector3(0, 0.1, 0)
		enemy_model.get_node("AnimationPlayer").play("walk")
		
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
		player_state._adjust_health(-enemy_state.ATTACK_DAMAGE)
		attack_float = 0
