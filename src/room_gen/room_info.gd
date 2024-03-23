extends Node

var north_door_offset: float
var west_door_offset: float
var south_door_offset: float
var east_door_offset: float

@export var north_door: Node3D
@export var west_door: Node3D
@export var south_door: Node3D
@export var east_door: Node3D

func _generate_offset():
	north_door_offset = north_door.position.x

