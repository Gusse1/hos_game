extends Node3D

var north_door_offset: float
var west_door_offset: float
var south_door_offset: float
var east_door_offset: float

@export var north_door: Node3D
@export var west_door: Node3D
@export var south_door: Node3D
@export var east_door: Node3D

var north_blocked: bool
var west_blocked: bool
var south_blocked: bool
var east_blocked: bool

func _generate_offset():
	
	north_blocked = false
	east_blocked = false
	west_blocked = false
	south_blocked = false
	
	if north_door:
		north_door_offset = north_door.position.x
	else:
		north_blocked = true
	if west_door:
		west_door_offset = west_door.position.z
	else:
		west_blocked = true
	if south_door:
		south_door_offset = south_door.position.x
	else:
		south_blocked = true
	if east_door:
		east_door_offset = east_door.position.z
	else:
		east_blocked = true

