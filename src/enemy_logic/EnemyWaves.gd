extends Node

# Array to hold reference to enemy spawn points
var spawnPoints = []
@export var enemySpawnPointsParent: Node3D

# Function to initialize spawn points
func _ready():
	# Get reference to the parent node containing spawn points
	
	# Iterate through children to find spawn points
	for child in enemySpawnPointsParent.get_children():
		# Add spawn point to the array
		spawnPoints.append(child.global_transform.origin)

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
	else:
		print("No spawn points available!")


func _on_room_trigger_area_entered(area):
	print_debug("Area", area)
	if area.name == "PlayerArea":
		print_debug("Pawn inside")
		spawnEnemy()
