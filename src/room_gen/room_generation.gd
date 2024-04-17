extends Node3D

# Define a list of room scenes
var roomScenes : Array[PackedScene] = [
	preload("res://assets/rooms/test_room_1.tscn"),
	preload("res://assets/rooms/upgrade_room_1.tscn"),
	preload("res://assets/rooms/hanging_plat.tscn")
]

var spawnedRooms = []
var spawnedExtraRooms = []
var room_map = []

@export var rooms_to_generate: int

var directions = ["north", "east", "south", "west"]

func _ready():
	_generate_rooms()
	_update_all_doors()

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
		spawnedRooms.back()._generate_offset()
		if room_num == 0:
			room_map.append(Vector2(0,0))
		else:
			# Choose a random direction:
			var availableDirections = directions.duplicate()
			
			if spawnedRooms[spawnedRooms.size()-2].north_blocked:
				_remove_dir(availableDirections, "north")
			if spawnedRooms[spawnedRooms.size()-2].south_blocked:
				_remove_dir(availableDirections, "south")
			if spawnedRooms[spawnedRooms.size()-2].east_blocked:
				_remove_dir(availableDirections, "east")
			if spawnedRooms[spawnedRooms.size()-2].west_blocked:
				_remove_dir(availableDirections, "west")
			
			var randomDirIndex = 0
			
			if availableDirections.size() > 0:
				randomDirIndex = randi() % availableDirections.size()
			else:
				print_debug("All dirs blocked for room:", spawnedRooms[spawnedRooms.back()].name)
				continue

			var randomDir = availableDirections[randomDirIndex]
			
			match randomDir:
				"north":
					if _spawn_north_room(spawnedRooms.size()-1) != 0:
						room_map.append(Vector2(room_map.back().x, room_map.back().y + 1))
					else:
						rooms_to_generate += 1
				"east":
					if _spawn_east_room(spawnedRooms.size()-1) != 0:
						room_map.append(Vector2(room_map.back().x + 1, room_map.back().y))
					else:
						rooms_to_generate += 1
				"south":
					if _spawn_south_room(spawnedRooms.size()-1) != 0:
						room_map.append(Vector2(room_map.back().x, room_map.back().y - 1))
					else:
						rooms_to_generate += 1
				"west":
					if _spawn_west_room(spawnedRooms.size()-1) != 0:
						room_map.append(Vector2(room_map.back().x - 1, room_map.back().y))
					else:
						rooms_to_generate += 1

func _spawn_north_room(room_num: int):
	var prev_room = spawnedRooms[room_num-1]
	
	if spawnedRooms[room_num].south_blocked or (Vector2(room_map.back().x, room_map.back().y + 1) in room_map):
		spawnedRooms[room_num].queue_free()
		spawnedRooms.remove_at(room_num)
		return 0
	
	var curr_room = spawnedRooms[room_num]
		
	var northDoorLocation = prev_room.position + prev_room.north_door.position
	var newPosition = northDoorLocation.x - curr_room.south_door_offset
	
	spawnedRooms[room_num-1].north_blocked = true
	spawnedRooms[room_num].south_blocked = true
	spawnedRooms[room_num].position = Vector3(newPosition, prev_room.position.y, prev_room.position.z)
	return 1
	
func _spawn_east_room(room_num: int):
	var prev_room = spawnedRooms[room_num-1]
	
	if spawnedRooms[room_num].west_blocked or (Vector2(room_map.back().x + 1, room_map.back().y) in room_map):
		spawnedRooms[room_num].call_deferred("queue_free")
		spawnedRooms.remove_at(room_num)
		return 0
	
	var curr_room = spawnedRooms[room_num]
		
	var eastDoorLocation = prev_room.position + prev_room.east_door.position
	var newPosition = eastDoorLocation.z - curr_room.west_door_offset
	
	spawnedRooms[room_num-1].east_blocked = true
	spawnedRooms[room_num].west_blocked = true
	spawnedRooms[room_num].position = Vector3(prev_room.position.x, prev_room.position.y, newPosition)
	return 1

func _spawn_south_room(room_num: int):
	var prev_room = spawnedRooms[room_num-1]
	
	if spawnedRooms[room_num].north_blocked or (Vector2(room_map.back().x, room_map.back().y - 1) in room_map):
		spawnedRooms[room_num].call_deferred("queue_free")
		spawnedRooms.remove_at(room_num)
		return 0
				
	var curr_room = spawnedRooms[room_num]
				
	var southDoorLocation = prev_room.position + prev_room.south_door.position
	var newPosition = southDoorLocation.x - curr_room.north_door_offset
	
	spawnedRooms[room_num-1].south_blocked = true
	spawnedRooms[room_num].north_blocked = true
	spawnedRooms[room_num].position = Vector3(newPosition, prev_room.position.y, prev_room.position.z)
	return 1
	
func _spawn_west_room(room_num: int):
	var prev_room = spawnedRooms[room_num-1]

	if spawnedRooms[room_num].east_blocked or (Vector2(room_map.back().x - 1, room_map.back().y) in room_map):
		spawnedRooms[room_num].call_deferred("queue_free")
		spawnedRooms.remove_at(room_num)
		return 0

	var curr_room = spawnedRooms[room_num]
	
	var westDoorLocation = prev_room.position + prev_room.west_door.position
	var newPosition = westDoorLocation.z - curr_room.east_door_offset
	
	spawnedRooms[room_num-1].west_blocked = true
	spawnedRooms[room_num].east_blocked = true
	spawnedRooms[room_num].position = Vector3(prev_room.position.x, prev_room.position.y, newPosition)
	return 1

func _update_all_doors():
	for room in spawnedRooms:
		room._update_doors()
