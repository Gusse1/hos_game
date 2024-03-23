extends Node3D

# Define a list of room scenes
var roomScenes : Array[PackedScene] = [
	preload("res://assets/rooms/test_room_1.tscn")
]

var spawnedRooms = []

@export var rooms_to_generate: int

func _ready():
	_generate_rooms()
	
func _generate_rooms():
	for room_num in rooms_to_generate:
		# Get a random index from the list
		var randomIndex = randi() % roomScenes.size()
		
		# Instantiate the random room
		var randomRoom = roomScenes[randomIndex].instantiate()
					
		self.get_tree().current_scene.add_child.call_deferred(randomRoom)
		spawnedRooms.append(randomRoom)
		
		spawnedRooms[room_num]._generate_offset()
				
		if room_num > 0:
			print_debug("Moving new room... with room_num: ", room_num)
			print_debug(spawnedRooms[room_num-1].position)
			var northDoorLocation = spawnedRooms[room_num-1].position.x + spawnedRooms[room_num-1].north_door_offset
			var newPosition = northDoorLocation + spawnedRooms[room_num].north_door_offset
			
			print_debug(newPosition)

			spawnedRooms[room_num].position = Vector3(newPosition, 0, 0)
			
		print_debug("NewRoomPos: ", randomRoom.position)	
	
	
