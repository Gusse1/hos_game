extends Node3D

# Define a list of room scenes
var roomScenes : Array[PackedScene] = [
	preload("res://assets/rooms/test_room_1.tscn")
]

var spawnedRooms = []

@export var rooms_to_generate: int

var directions = ["north", "east", "south", "west"]

func _ready():
	_generate_rooms()

func _remove_dir(available_directions, removable):
	var iterator = 0
	for dir in available_directions:
		if dir == removable:
			available_directions.remove_at(iterator)
		iterator+=1

func _generate_rooms():
	for room_num in rooms_to_generate:
		# Get a random index from the list
		var randomIndex = randi() % roomScenes.size()
		
		# Instantiate the random room
		var randomRoom = roomScenes[randomIndex].instantiate()
					
		self.add_child.call_deferred(randomRoom)
		spawnedRooms.append(randomRoom)
		
		spawnedRooms[room_num]._generate_offset()
				
		if room_num > 0:
			# Choose a random direction:
			var availableDirections = directions.duplicate()
			
			if spawnedRooms[room_num-1].north_blocked:
				print_debug("northblock")
				_remove_dir(availableDirections, "north")
			if spawnedRooms[room_num-1].south_blocked:
				_remove_dir(availableDirections, "south")
			if spawnedRooms[room_num-1].east_blocked:
				_remove_dir(availableDirections, "east")
			if spawnedRooms[room_num-1].west_blocked:
				_remove_dir(availableDirections, "west")
			
			print_debug(availableDirections)
			var randomDirIndex = randi() % availableDirections.size()
			var randomDir = availableDirections[randomDirIndex]
			
			match randomDir:
				"north":
					_spawn_north_room(room_num)
				"east":
					_spawn_east_room(room_num)
				"south":
					_spawn_south_room(room_num)
				"west":
					_spawn_west_room(room_num)
	
func _spawn_north_room(room_num: int):
	var prev_room = spawnedRooms[room_num-1]
	var curr_room = spawnedRooms[room_num]
	var northDoorLocation = prev_room.position + prev_room.north_door.position
	var newPosition = northDoorLocation.x + curr_room.north_door_offset
	
	spawnedRooms[room_num].south_blocked = true
	spawnedRooms[room_num].position = Vector3(newPosition, prev_room.position.y, prev_room.position.z)

func _spawn_east_room(room_num: int):
	var prev_room = spawnedRooms[room_num-1]
	var curr_room = spawnedRooms[room_num]
	var eastDoorLocation = prev_room.position + prev_room.east_door.position
	var newPosition = eastDoorLocation.z + curr_room.east_door_offset
	
	spawnedRooms[room_num].west_blocked = true
	spawnedRooms[room_num].position = Vector3(prev_room.position.x, prev_room.position.y, newPosition)

func _spawn_south_room(room_num: int):
	var prev_room = spawnedRooms[room_num-1]
	var curr_room = spawnedRooms[room_num]
	var southDoorLocation = prev_room.position + prev_room.south_door.position
	var newPosition = southDoorLocation.x + curr_room.south_door_offset
	
	spawnedRooms[room_num].north_blocked = true
	spawnedRooms[room_num].position = Vector3(newPosition, prev_room.position.y, prev_room.position.z)
	
func _spawn_west_room(room_num: int):
	var prev_room = spawnedRooms[room_num-1]
	var curr_room = spawnedRooms[room_num]
	var westDoorLocation = prev_room.position + prev_room.west_door.position
	var newPosition = westDoorLocation.z + curr_room.west_door_offset
	
	spawnedRooms[room_num].east_blocked = true
	spawnedRooms[room_num].position = Vector3(prev_room.position.x, prev_room.position.y, newPosition)
