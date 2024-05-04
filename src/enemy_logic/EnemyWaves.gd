extends Node

# Array to hold reference to enemy spawn points
var spawnPoints = []
var target_enemy_points: int
var current_enemy_count: int
var difficulty: int
@export var enemySpawnPointsParent: Node3D

func _ready():
	# Iterate through children to find spawn points
	for child in enemySpawnPointsParent.get_children():
		# Add spawn point to the array
		spawnPoints.append(child.global_transform.origin)
	
	difficulty = get_tree().get_root().get_node("Debug World").get_node("Pawn").get_node("PlayerState").difficulty

# Function to spawn enemies at random spawn point
func spawnEnemy():
	# Check if there are any spawn points available
	if spawnPoints.size() > 0:
		# Choose a random spawn point
		var spawnPointIndex = randi() % spawnPoints.size()
		var spawnPoint = spawnPoints[spawnPointIndex]
		
		# Instantiate the enemy at the chosen spawn point
		var enemyScene = preload("res://assets/enemies/sprinter.tscn")
		var enemy = enemyScene.instantiate()
		enemy.position = spawnPoint
		add_child(enemy)
		current_enemy_count += 1
		target_enemy_points -= enemy.get_node("CharacterBody3D/EnemyResources").COST
		
		spawnPoints.remove_at(spawnPointIndex)
	else:
		print("No spawn points available!")
		return -1

func startWaveSpawn():
	# Calculate half of the difficulty
	var half_difficulty = difficulty / 2
	# Generate a random integer within the specified range
	var random_number = randi() % (difficulty - half_difficulty + 1) + half_difficulty
	
	print_debug("target_enemy_points = ", random_number)
	
	target_enemy_points = random_number
	
	while target_enemy_points > 0:
		var ret_val = spawnEnemy()
		if ret_val == -1:
			return ret_val

# Signal listener
func _on_room_trigger_area_entered(area):
	print_debug("Area", area)
	if area.name == "PlayerArea":
		print_debug("Pawn inside")
		startWaveSpawn()
