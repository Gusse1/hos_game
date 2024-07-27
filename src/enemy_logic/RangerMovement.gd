extends CharacterBody3D

@onready var shared_variables: Node = get_tree().current_scene.get_node("SharedVariables")

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_model: Node3D = $enemy
@onready var enemy_state: Node = $EnemyResources
@onready var attack_float : float = 0
@export var attack_float_cumulation : float = 1.25
@onready var indicator_light: OmniLight3D = $enemy/OmniLight3D

var enemy_spawner = preload("res://assets/enemies/enemy_spawner_small.tscn")
var start = true

var projectile = preload("res://assets/enemies/ranger_projectile.tscn")

var timer_set = false
var time: float
var start_time: float
var inst_enemy_spawner

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	
func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame


func _enable_enemy():
	start = true


func _physics_process(delta):
	time+=delta
	if start:
		if not timer_set:
			start_time = time
			timer_set = true
			
		enemy_state.ACTIVE = false
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
		attack_float = attack_float + (attack_float_cumulation * delta)
		
		var current_agent_position: Vector3 = global_position
		enemy_model.look_at(shared_variables.player_body.global_transform.origin, Vector3.UP)
		
		if attack_float > 4:
			indicator_light.visible = true
		
		# Attack player if in attack range
		if attack_float > 5:
			_shoot_projectile()
		var direction = (shared_variables.player_body.global_transform.origin - global_transform.origin).normalized()




func _shoot_projectile():
	indicator_light.visible = false
	var direction = (shared_variables.player_body.global_transform.origin - global_transform.origin).normalized()
	var projectile_instance = projectile.instantiate()

	# Set the position of the projectile
	projectile_instance.global_position = self.global_position
	projectile_instance.look_at(shared_variables.player_body.global_transform.origin, Vector3.UP)
	projectile_instance.move_direction = direction
	projectile_instance.scale = Vector3(5,5,5)
	get_tree().get_root().add_child(projectile_instance)
	
	attack_float = 0

func _damage_player(delta):
	attack_float += attack_float_cumulation*delta
	if attack_float > 1:
		shared_variables.player_state._adjust_health(-enemy_state.ATTACK_DAMAGE)
		shared_variables.player_state._camera_flash()
		print_debug("Player attacked with these vars: " + str(shared_variables.player_body.global_position) + "agent velocity: " + str(velocity.normalized()))
		attack_float = 0
